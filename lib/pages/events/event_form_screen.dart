import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/services/api.dart';

class EventFormScreen extends StatefulWidget {
  final EventModel? event;

  const EventFormScreen({super.key, this.event});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedBoard;
  String? uploadedFilePath;

  // Controllers for text fields
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  final contactNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final clubController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode venueFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      final event = widget.event!;
      titleController.text = event.title;
      venueController.text = event.venue;
      descriptionController.text = event.description;
      clubController.text=event.clubOrg;

      selectedDate = event.startDateTime;
      selectedStartTime = TimeOfDay.fromDateTime(event.startDateTime);
      selectedEndTime = TimeOfDay.fromDateTime(event.endDateTime);

      selectedBoard = event.board;
      //uploadedFilePath = event.imageUrl;
    }
  }

  void _unfocusAll() {
    titleFocusNode.unfocus();
    venueFocusNode.unfocus();
    descriptionFocusNode.unfocus();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    venueFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _unfocusAll();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1b1b1d),
        appBar: AppBar(
          title: Text(widget.event == null ? 'Add Event' : "Edit Event",
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: const Color(0xFF273141),
          leading: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    hintText: 'Title *',
                    hintStyle: const TextStyle(
                        color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 7),

                // Image Upload
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      setState(() {
                        uploadedFilePath = result.files.single.path;
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 500,
                    decoration: BoxDecoration(
                      color: const Color(0xFF273141),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              uploadedFilePath ?? 'Upload Photo',
                              style: const TextStyle(
                                color: Color(0xFFA2ACC0),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.upload_sharp,
                              color: Color(0xFFA2ACC0)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 7),
                widget.event == null
                    ? DropdownButtonFormField<String>(
                  value: selectedBoard,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'Board *',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: const TextStyle(
                        color: Color(0xFFA2ACC0),
                        fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                  dropdownColor: const Color(0xFF273141),
                  items: [
                    "Academic",
                    "Cultural",
                    "Technical",
                    "Sports",
                    "Welfare",
                    "Miscellaneous",
                    "SWC"
                  ]
                      .map((board) => DropdownMenuItem(
                      value: board,
                      child: Text(board,
                          style:
                          const TextStyle(color: Colors.white))))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBoard = value;
                    });
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.arrow_drop_down,
                        color: Color(0xFFA2ACC0)),
                  ),
                )
                    : TextField(
                  //controller: TextEditingController();,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    hintText: selectedBoard,
                    hintStyle: const TextStyle(
                        color: Color(0xFFA2ACC0),
                        fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                  enabled: false,
                ),

                const SizedBox(height: 7),

                // Text field for Club
                TextField(
                  controller: clubController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    hintText: "Club Name",
                    hintStyle: const TextStyle(
                        color: Color(0xFFA2ACC0),
                        fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                  enabled: true,
                ),

                const SizedBox(height: 7),

                // Date and Time Pickers
                _buildDateTimePickers(),

                const SizedBox(height: 7),

                // Venue
                TextField(
                  controller: venueController,
                  focusNode: venueFocusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    hintText: 'Venue *',
                    hintStyle: const TextStyle(
                        color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                // Description
                TextField(
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    hintText: 'Description',
                    hintStyle: const TextStyle(
                        color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                      const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          clubController.text.isNotEmpty &&
                          venueController.text.isNotEmpty &&
                          selectedDate != null &&
                          selectedStartTime != null &&
                          selectedEndTime != null &&
                          uploadedFilePath != null) {

                        if (widget.event == null) {
                          _submitForm();
                        } else {
                          _editForm();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill in all required fields.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF76ACFF),
                      minimumSize: const Size(double.infinity, 53),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Color(0xFF00210B))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build Date and Time Pickers
  Widget _buildDateTimePickers() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: 145,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF273141),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                      : 'DD/MM/YYYY',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null
                        ? Colors.white
                        : const Color(0xFFA2ACC0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectStartTime(context),
            child: Container(
              width: 145,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF273141),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  selectedStartTime != null
                      ? selectedStartTime!.format(context)
                      : 'Start Time',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedStartTime != null
                        ? Colors.white
                        : const Color(0xFFA2ACC0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectEndTime(context),
            child: Container(
              width: 145,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF273141),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  selectedEndTime != null
                      ? selectedEndTime!.format(context)
                      : 'End Time',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedEndTime != null
                        ? Colors.white
                        : const Color(0xFFA2ACC0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Select Date Method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Select Start Time Method
  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedStartTime = pickedTime;
      });
    }
  }

  // Select End Time Method
  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedEndTime = pickedTime;
        print("selectedEndTime =>>${selectedEndTime}");
      });
    }
  }

  //TODO change the form data
  // Submit Form Method
  Future<void> _submitForm() async {
    var fileName = uploadedFilePath!.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(uploadedFilePath!, filename: fileName),
      'title': titleController.text,
      'description': descriptionController.text,
      'club_org': clubController,
      'startDateTime': _formatDateTime(selectedDate!,selectedStartTime!),
      'endDateTime': _formatDateTime(selectedDate!,selectedEndTime!),
      'venue': venueController.text,
      'categories':<String>["Academic", "All"], //TODO editable categories
      'board': selectedBoard,
    });

    Map<String,dynamic> res = {};
    try {
      res = await APIService().postEvent(formData);
    } catch (e) {
      print(e.toString());
    }

    if (res['saved_successfully']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event submitted successfully!')),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some unknown error occurred!')),
      );
    }
  }

  Future<void> _editForm() async {
    var res = {};
    final formData = FormData.fromMap({
      'title': titleController.text,
      'description': descriptionController.text,
      'club_org': clubController,
      'startDateTime': _formatDateTime(selectedDate!,selectedStartTime!),
      'endDateTime': _formatDateTime(selectedDate!,selectedEndTime!),
      'venue': venueController.text,
      'categories': widget.event!.categories,
      'board': selectedBoard,
      'file':uploadedFilePath != null ? (await MultipartFile.fromFile(uploadedFilePath!)): null,
      'imageURL' : uploadedFilePath == null ? widget.event!.imageUrl : null,
      'compressedImageURL' : uploadedFilePath == null ? widget.event!.compressedImageUrl : null,
    });

    try {
      res = await APIService().putEvent(widget.event!.id, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!'), duration: const Duration(seconds: 2),),
        
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.of(context).pop();
    } catch (e) {
      print("Error updating event: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some unknown error occurred!')),
      );
    }
  }
}


String _formatDateTime(DateTime selectedDate, TimeOfDay time) {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

  final String formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  final String finalTime = "$formattedDate$formattedTime:00.000Z";

  return finalTime;
}
