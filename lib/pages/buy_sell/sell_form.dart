import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:onestop_ui/constants/corner_radius.dart';
import 'package:onestop_ui/constants/spacing.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';
import 'dart:convert';
import 'package:onestop_dev/repository/bns_repository.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:onestop_dev/services/moderation_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class SellItemForm extends StatefulWidget {
  static const String id = "/sellItemForm";
  final String? type; 
  final dynamic existingItem; 

  const SellItemForm({super.key, this.type, this.existingItem});

  @override
  State<SellItemForm> createState() => _SellItemFormState();
}

class _SellItemFormState extends State<SellItemForm> {
  int _currentStep = 0;
  final List<File> _photos = [];
  final List<TransformationController> _transformationControllers = [];
  final List<GlobalKey> _repaintKeys = [];
  int _selectedPhotoIndex = 0;
  static const int _maxPhotos = 3;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isBrandNew = false;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  bool get isEditMode => widget.existingItem != null;
  bool get isSellMode => widget.type == "Sell";

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadExistingData();
      _currentStep = 1;
    }
  }

  void _loadExistingData() {
    final item = widget.existingItem;
    _productNameController.text = item?.title ?? '';
    _productPriceController.text = item?.price?.toString() ?? '';
    if (isSellMode) {
      _descriptionController.text = item?.description ?? '';
      _isBrandNew = item?.isNew ?? false;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _descriptionController.dispose();
    for (var controller in _transformationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  
  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      
     
      if (bytes.length < 2 * 1024 * 1024) {
        print('Image already small enough: ${bytes.length} bytes');
        return file;
      }
      
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        print('Could not decode image for compression');
        return file;
      }
      
      
      if (image.width > 1500 || image.height > 1500) {
        print('Resizing image from ${image.width}x${image.height}');
        if (image.width > image.height) {
          image = img.copyResize(image, width: 1500);
        } else {
          image = img.copyResize(image, height: 1500);
        }
        print('Resized to ${image.width}x${image.height}');
      }
      
     
      final compressedBytes = img.encodeJpg(image, quality: 95);
      
      final tempDir = await getTemporaryDirectory();
      final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await compressedFile.writeAsBytes(compressedBytes);
      
      print('Image compressed: ${file.lengthSync()} -> ${compressedFile.lengthSync()} bytes');
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return file;
    }
  }

  Future<File> _applyTransformAndExport(int index) async {
    final File originalFile = _photos[index];
    final Matrix4 matrix = _transformationControllers[index].value.clone();

    final bytes = await originalFile.readAsBytes();
    img.Image? original = img.decodeImage(bytes);

    if (original == null) return originalFile;

   
    final double scale = matrix.storage[0];
    final double translateX = matrix.storage[12];
    final double translateY = matrix.storage[13];

   
    const double viewportSize = 300;

    final double cropSize = viewportSize / scale;

    double cropX = (-translateX) / scale;
    double cropY = (-translateY) / scale;

    cropX = cropX.clamp(0, original.width - cropSize);
    cropY = cropY.clamp(0, original.height - cropSize);

    img.Image cropped = img.copyCrop(
      original,
      x: cropX.toInt(),
      y: cropY.toInt(),
      width: cropSize.toInt(),
      height: cropSize.toInt(),
    );

    img.Image resized = img.copyResize(
      cropped,
      width: 1000,
      height: 1000,
    );

    final tempDir = await getTemporaryDirectory();
    final file = File(
        '${tempDir.path}/final_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await file.writeAsBytes(img.encodeJpg(resized, quality: 92));
    return file;
  }

 
  Future<void> _pickPhoto() async {
    if (_photos.length >= _maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You can only upload up to $_maxPhotos photos'),
          backgroundColor: OColor.red600,
        ),
      );
      return;
    }

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) return;

     
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(OColor.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Processing image...'),
              ],
            ),
            duration: Duration(seconds: 3),
            backgroundColor: OColor.gray700,
          ),
        );
      }

      File file = File(picked.path);
      File compressed = await _compressImage(file);

      if (mounted) {
        setState(() {
          _photos.add(compressed);
          _transformationControllers.add(TransformationController());
          _repaintKeys.add(GlobalKey());
          _selectedPhotoIndex = _photos.length - 1;
        });

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading image: $e'),
            backgroundColor: OColor.red600,
          ),
        );
      }
    }
  }

 
  Future<void> _replacePhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (picked == null) return;

     
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(OColor.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Processing image...'),
              ],
            ),
            duration: Duration(seconds: 3),
            backgroundColor: OColor.gray700,
          ),
        );
      }

      File file = File(picked.path);
      File compressed = await _compressImage(file);

      if (mounted) {
        setState(() {
          _photos[_selectedPhotoIndex] = compressed;
          _transformationControllers[_selectedPhotoIndex].value = Matrix4.identity();
        });

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      debugPrint('Error replacing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading image: $e'),
            backgroundColor: OColor.red600,
          ),
        );
      }
    }
  }

 
  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
      _transformationControllers.removeAt(index);
      _repaintKeys.removeAt(index);
      if (_selectedPhotoIndex >= _photos.length && _selectedPhotoIndex > 0) {
        _selectedPhotoIndex = _photos.length - 1;
      }
    });
  }

 
  void _goToNextStep() {
    setState(() => _currentStep = 1);
  }

  void _goToPreviousStep() {
    if (_currentStep == 1) {
      setState(() => _currentStep = 0);
    } else {
      Navigator.pop(context);
    }
  }

  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      print('Image converted to base64: ${base64String.length} characters');
      return base64String;
    } catch (e) {
      print('Error converting image to base64: $e');
      rethrow;
    }
  }

  
  Future<void> _submitForm() async {
   
    if (_productNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter product name'),
          backgroundColor: OColor.red600,
        ),
      );
      return;
    }

    if (_productPriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter product price'),
          backgroundColor: OColor.red600,
        ),
      );
      return;
    }

    if (_photos.isEmpty && !isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload at least one photo'),
          backgroundColor: OColor.red600,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
     
      
      
      final isTitleValid = await ModerationService().validateBuyOrSell(_productNameController.text.trim());
      if (!isTitleValid) {
        Fluttertoast.showToast(
          msg: 'Please enter an appropriate title!',
          backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      
      if (isSellMode && _descriptionController.text.trim().isNotEmpty) {
        final isDescValid = await ModerationService().validateBuyOrSell(_descriptionController.text.trim());
        if (!isDescValid) {
          Fluttertoast.showToast(
            msg: 'Please enter an appropriate description!',
            backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
          );
          setState(() {
            _isSubmitting = false;
          });
          return;
        }
      }

     
      String imageString = '';
      if (_photos.isNotEmpty) {
        print('Capturing transformed image...');
        final transformedImage = await _applyTransformAndExport(0);
        imageString = await _convertImageToBase64(transformedImage);
      }

      
      String phone = '';
      if (LoginStore.userData.containsKey("phoneNumber")) {
        phone = LoginStore.userData["phoneNumber"]?.toString() ?? '';
      }

      
      Map<String, String> data = {
        'title': _productNameController.text.trim(),
        'description': isSellMode ? _descriptionController.text.trim() : '',
        'price': _productPriceController.text.trim(),
        'contact': phone,
        'image': imageString,
        'name': LoginStore.userData["name"]?.toString() ?? '',
        'email': LoginStore.userData["outlookEmail"]?.toString() ?? '',
      };

      // print('Submitting data to backend...');
      // print('Data keys: ${data.keys}');
      // print('Title: ${data['title']}');
      // print('Price: ${data['price']}');
      // print('Contact: ${data['contact']}');
      // print('Image length: ${imageString.length}');

    
      var res = {};
      if (isSellMode) {
        res = await BnsRepository().postSellData(data);
      } else {
        res = await BnsRepository().postBuyData(data);
      }

      print('Backend response: $res');

      if (!mounted) return;

      if (res["saved_successfully"] == true) {
        Fluttertoast.showToast(
          msg: isEditMode ? "Product updated successfully!" : "Product posted successfully!",
          backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
        );
        Navigator.pop(context, true);
      } else {
        String errorMsg = "Some error occurred! Please try again.";
        
        if (res["image_safe"] == false) {
          errorMsg = "The chosen image is NSFW!";
        } else if (res["error"] != null) {
          errorMsg = "Error: ${res["error"]}";
        } else if (res["message"] != null) {
          errorMsg = res["message"].toString();
        }
        
        print('Error message: $errorMsg');
        
        Fluttertoast.showToast(
          msg: errorMsg,
          backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
          toastLength: Toast.LENGTH_LONG,
        );
        
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      print('Error submitting form: $e');
      print('Stack trace: $stackTrace');
      
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: OneStopColors.cardColor2.withValues(alpha: 0.7),
        toastLength: Toast.LENGTH_LONG,
      );
      
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = isEditMode
        ? (isSellMode ? "Edit item" : "Edit request")
        : (isSellMode ? "Sell an item" : "Request an item");

    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_24_regular,
            color: OColor.gray800,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: OTextStyle.headingMedium.copyWith(
            color: OColor.gray800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          _productNameController,
          _productPriceController,
        ]),
        builder: (context, child) {
          return Column(
            children: [
              
              if (!isEditMode) _StepIndicator(currentStep: _currentStep),

              
              if (_isSubmitting)
                LinearProgressIndicator(
                  backgroundColor: OColor.gray200,
                  valueColor: AlwaysStoppedAnimation<Color>(OColor.green600),
                ),

              
              Expanded(
                child: _currentStep == 0 && !isEditMode
                    ? _UploadPhotoBody(
                        photos: _photos,
                        selectedPhotoIndex: _selectedPhotoIndex,
                        maxPhotos: _maxPhotos,
                        transformationControllers: _transformationControllers,
                        repaintKeys: _repaintKeys,
                        onAddPhoto: _pickPhoto,
                        onReplacePhoto: _replacePhoto,
                        onRemovePhoto: _removePhoto,
                        onSelectPhoto: (index) {
                          setState(() => _selectedPhotoIndex = index);
                        },
                      )
                    : _AddDetailsBody(
                        productNameController: _productNameController,
                        productPriceController: _productPriceController,
                        descriptionController: _descriptionController,
                        isBrandNew: _isBrandNew,
                        isSellMode: isSellMode,
                        isSubmitting: _isSubmitting,
                        onBrandNewChanged: (value) {
                          setState(() {
                            _isBrandNew = value;
                          });
                        },
                      ),
              ),

              
              _BottomActions(
                currentStep: _currentStep,
                canProceed: _currentStep == 0
                    ? _photos.isNotEmpty
                    : _productNameController.text.isNotEmpty &&
                        _productPriceController.text.isNotEmpty,
                isSubmitting: _isSubmitting,
                isEditMode: isEditMode,
                onBack: _goToPreviousStep,
                onNext: _goToNextStep,
                onPost: _submitForm,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.xl,
        vertical: OSpacing.m,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          Positioned(
            top: 14,
            left: 28,
            right: 20,
            child: Container(
              height: 2,
              color: currentStep > 0
                  ? OColor.green600
                  : OColor.gray200,
            ),
          ),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepItem(
                index: 1,
                label: "UPLOAD PHOTO",
                isCompleted: currentStep > 0,
                isActive: currentStep == 0,
              ),
              _StepItem(
                index: 2,
                label: "ADD DETAILS",
                isCompleted: currentStep > 1,
                isActive: currentStep == 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int index;
  final String label;
  final bool isCompleted;
  final bool isActive;

  const _StepItem({
    required this.index,
    required this.label,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Widget child;

    if (isCompleted) {
      bgColor = OColor.green600;
      child = Icon(Icons.check, color: OColor.white, size: 14);
    } else if (isActive) {
      bgColor = OColor.green600;
      child = Text(
        '$index',
        style: OTextStyle.bodySmall.copyWith(
          color: OColor.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      bgColor = OColor.gray200;
      child = Text(
        '$index',
        style: OTextStyle.bodySmall.copyWith(
          color: OColor.gray600,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: OTextStyle.bodySmall.copyWith(
            color:
                isActive || isCompleted ? OColor.green600 : OColor.gray600,
            fontWeight: FontWeight.w600,
            fontSize: 10,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _UploadPhotoBody extends StatelessWidget {
  final List<File> photos;
  final int selectedPhotoIndex;
  final int maxPhotos;
  final List<TransformationController> transformationControllers;
  final List<GlobalKey> repaintKeys;
  final Future<void> Function() onAddPhoto;
  final Future<void> Function() onReplacePhoto;
  final void Function(int) onRemovePhoto;
  final void Function(int) onSelectPhoto;

  const _UploadPhotoBody({
    required this.photos,
    required this.selectedPhotoIndex,
    required this.maxPhotos,
    required this.transformationControllers,
    required this.repaintKeys,
    required this.onAddPhoto,
    required this.onReplacePhoto,
    required this.onRemovePhoto,
    required this.onSelectPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPhotos = photos.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(OSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            "Upload photo(s) of the product",
            style: OTextStyle.headingSmall.copyWith(
              color: OColor.gray800,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          Text(
            "You can upload upto $maxPhotos photos of the product",
            style: OTextStyle.bodySmall.copyWith(
              color: OColor.gray600,
            ),
          ),
          const SizedBox(height: OSpacing.m),

          
          if (hasPhotos) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: OSpacing.m,
                vertical: OSpacing.s,
              ),
              decoration: BoxDecoration(
                color: OColor.blue600.withOpacity(0.3),
                borderRadius: BorderRadius.circular(OCornerRadius.s),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FluentIcons.info_24_regular,
                    color: OColor.blue400,
                    size: 20,
                  ),
                  const SizedBox(width: OSpacing.s),
                  Expanded(
                    child: Text(
                      "USE TWO FINGERS TO ADJUST THE IMAGE SIZE AND POSITION",
                      style: OTextStyle.bodySmall.copyWith(
                        color: OColor.blue400,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: OSpacing.m),
          ],

          
          if (hasPhotos)
            _PhotoPreview(
              photos: photos,
              selectedPhotoIndex: selectedPhotoIndex,
              transformationControllers: transformationControllers,
              repaintKeys: repaintKeys,
              onSelectPhoto: onSelectPhoto,
              onRemovePhoto: onRemovePhoto,
            )
          else
            _AddPhotoButton(onTap: onAddPhoto),

          const SizedBox(height: OSpacing.m),

         
          if (hasPhotos) ...[
            
            _OutlinedActionButton(
              icon: FluentIcons.arrow_sync_24_regular,
              label: "Replace Selected",
              onTap: onReplacePhoto,
            ),
            const SizedBox(height: OSpacing.s),

           
            if (photos.length < maxPhotos)
              _OutlinedActionButton(
                icon: Icons.add,
                label: "Add more photos",
                onTap: onAddPhoto,
              ),
          ],
        ],
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  final List<File> photos;
  final int selectedPhotoIndex;
  final List<TransformationController> transformationControllers;
  final List<GlobalKey> repaintKeys;
  final void Function(int) onSelectPhoto;
  final void Function(int) onRemovePhoto;

  const _PhotoPreview({
    required this.photos,
    required this.selectedPhotoIndex,
    required this.transformationControllers,
    required this.repaintKeys,
    required this.onSelectPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        ClipRRect(
          borderRadius: BorderRadius.circular(OCornerRadius.l),
          child: Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.black,
                child: RepaintBoundary(
                  key: repaintKeys[selectedPhotoIndex],
                  child: InteractiveViewer(
                    transformationController: transformationControllers[selectedPhotoIndex],
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Center(
                      child: Image.file(
                        photos[selectedPhotoIndex],
                        fit: BoxFit.contain,
                        cacheWidth: 800, // Optimize memory
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return Icon(Icons.error, color: OColor.red500);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Remove Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => onRemovePhoto(selectedPhotoIndex),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: OColor.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: OColor.gray800,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: OSpacing.m),

        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(photos.length, (index) {
              final bool isSelected = index == selectedPhotoIndex;
              return Padding(
                padding: EdgeInsets.only(right: index < photos.length - 1 ? OSpacing.s : 0),
                child: GestureDetector(
                  onTap: () => onSelectPhoto(index),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(OCornerRadius.s),
                      border: Border.all(
                        color: isSelected ? OColor.green600 : OColor.gray300,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(OCornerRadius.s - 2),
                      child: Image.file(
                        photos[index],
                        fit: BoxFit.cover,
                        cacheWidth: 180,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  final Future<void> Function() onTap;

  const _AddPhotoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OColor.white,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: OSpacing.xxs + 2),
          decoration: BoxDecoration(
            border: Border.all(color: OColor.gray300, width: 1),
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: OColor.green600,
                size: 18,
              ),
              const SizedBox(width: OSpacing.xs),
              Text(
                "Add Photo",
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.green600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Future<void> Function() onTap;

  const _OutlinedActionButton({
    this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OColor.white,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: OSpacing.xxs + 2),
          decoration: BoxDecoration(
            border: Border.all(color: OColor.gray300, width: 1),
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: OColor.green600, size: 18),
                const SizedBox(width: OSpacing.xs),
              ],
              Text(
                label,
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.green600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddDetailsBody extends StatelessWidget {
  final TextEditingController productNameController;
  final TextEditingController productPriceController;
  final TextEditingController descriptionController;
  final bool isBrandNew;
  final bool isSellMode;
  final bool isSubmitting;
  final void Function(bool) onBrandNewChanged;

  const _AddDetailsBody({
    required this.productNameController,
    required this.productPriceController,
    required this.descriptionController,
    required this.isBrandNew,
    required this.isSellMode,
    required this.isSubmitting,
    required this.onBrandNewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(OSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Text(
            "Enter Details",
            style: OTextStyle.headingSmall.copyWith(
              color: OColor.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          Text(
            "Your personal details like mail ID and phone number will be visible to others once you post the ad.",
            style: OTextStyle.bodySmall.copyWith(
              color: OColor.gray600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: OSpacing.l),

         
          Text(
            "Product Name",
            style: OTextStyle.bodyMedium.copyWith(
              color: OColor.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          _InputField(
            controller: productNameController,
            hintText: "Dryer, Mouse, Table Fan, etc.",
            keyboardType: TextInputType.text,
            enabled: !isSubmitting,
          ),

          const SizedBox(height: OSpacing.m),

          
          Text(
            "Product Price",
            style: OTextStyle.bodyMedium.copyWith(
              color: OColor.gray800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: OSpacing.xs),
          _InputField(
            controller: productPriceController,
            hintText: "e.g. 100",
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            enabled: !isSubmitting,
          ),

         
          if (isSellMode) ...[
            const SizedBox(height: OSpacing.m),

            
            Text(
              "Description",
              style: OTextStyle.bodyMedium.copyWith(
                color: OColor.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: OSpacing.xs),
            _InputField(
              controller: descriptionController,
              hintText: "Add a brief description, original price, condition, and any other details about your item.",
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              enabled: !isSubmitting,
            ),

            const SizedBox(height: OSpacing.l),

           
            Container(
              padding: const EdgeInsets.all(OSpacing.m),
              decoration: BoxDecoration(
                color: OColor.white,
                borderRadius: BorderRadius.circular(OCornerRadius.m),
                border: Border.all(color: OColor.gray200, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Brand New",
                          style: OTextStyle.bodyMedium.copyWith(
                            color: OColor.gray800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Toggle on if your item is completely new and unused.",
                          style: OTextStyle.bodySmall.copyWith(
                            color: OColor.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: OSpacing.m),
                  Switch(
                    value: isBrandNew,
                    onChanged: isSubmitting ? null : onBrandNewChanged,
                    activeColor: OColor.green600,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool enabled;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      enabled: enabled,
      style: OTextStyle.bodyMedium.copyWith(
        color: OColor.gray800,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: OTextStyle.bodyMedium.copyWith(
          color: OColor.gray400,
        ),
        filled: true,
        fillColor: OColor.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.s,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: OColor.gray200, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: OColor.gray200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: OColor.green600, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: OColor.gray200, width: 1),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final int currentStep;
  final bool canProceed;
  final bool isSubmitting;
  final bool isEditMode;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onPost;

  const _BottomActions({
    required this.currentStep,
    required this.canProceed,
    required this.isSubmitting,
    required this.isEditMode,
    required this.onBack,
    required this.onNext,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStep0 = currentStep == 0;

    return Container(
      color: OColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: OSpacing.l,
        vertical: OSpacing.m,
      ),
      child: Row(
        children: [
          
          Expanded(
            child: _LeftButton(
              isStep0: isStep0,
              isSubmitting: isSubmitting,
              isEditMode: isEditMode,
              onTap: onBack,
            ),
          ),

          const SizedBox(width: OSpacing.m),

         
          Expanded(
            child: _RightButton(
              isStep0: isStep0,
              canProceed: canProceed,
              isSubmitting: isSubmitting,
              isEditMode: isEditMode,
              onNext: onNext,
              onPost: onPost,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftButton extends StatelessWidget {
  final bool isStep0;
  final bool isSubmitting;
  final bool isEditMode;
  final VoidCallback onTap;

  const _LeftButton({
    required this.isStep0,
    required this.isSubmitting,
    required this.isEditMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OColor.white,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: isSubmitting ? null : onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: OColor.gray300, width: 1),
            borderRadius: BorderRadius.circular(OCornerRadius.m),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isStep0 && !isEditMode
                    ? FluentIcons.dismiss_24_regular
                    : FluentIcons.arrow_left_24_regular,
                color: OColor.gray800,
                size: 18,
              ),
              const SizedBox(width: OSpacing.xs),
              Text(
                isStep0 && !isEditMode ? "Cancel" : "Back",
                style: OTextStyle.bodyMedium.copyWith(
                  color: OColor.gray800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RightButton extends StatelessWidget {
  final bool isStep0;
  final bool canProceed;
  final bool isSubmitting;
  final bool isEditMode;
  final VoidCallback onNext;
  final VoidCallback onPost;

  const _RightButton({
    required this.isStep0,
    required this.canProceed,
    required this.isSubmitting,
    required this.isEditMode,
    required this.onNext,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = canProceed 
        ? OColor.green600 
        : OColor.green600.withOpacity(0.4);

   
    String buttonText;
    if (isEditMode) {
      buttonText = "Update";
    } else if (isStep0) {
      buttonText = "Next";
    } else {
      buttonText = "Post";
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      child: InkWell(
        onTap: (canProceed && !isSubmitting) 
            ? (isStep0 && !isEditMode ? onNext : onPost) 
            : null,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        child: Container(
          height: 48,
          child: isSubmitting
              ? Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(OColor.white),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: OTextStyle.bodyMedium.copyWith(
                        color: OColor.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: OSpacing.xs),
                    Icon(
                      isEditMode
                          ? FluentIcons.checkmark_24_regular
                          : (isStep0
                              ? FluentIcons.arrow_right_24_regular
                              : FluentIcons.checkmark_24_regular),
                      color: OColor.white,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}