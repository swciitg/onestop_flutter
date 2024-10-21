import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/services/api.dart';
import 'package:onestop_dev/stores/login_store.dart';

import '../../globals/my_fonts.dart';
import '../../models/event_scheduler/admin_model.dart';
import '../../stores/event_store.dart';
import 'package:provider/provider.dart';

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
  late String selectedClub;

  // Controllers for text fields
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  final contactNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode titleFocusNode = FocusNode();
  final FocusNode venueFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  late List<String> clubs;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();


    Admin? admin= context.read<EventsStore>().admin;
    final userClubs = admin?.getUserClubs(LoginStore.userData['outlookEmail']!);
    selectedBoard= userClubs?.first.name;

    clubs = userClubs!.first.members.clubsOrgs;
    selectedClub=clubs.first;
    log("selectedBoard== $selectedBoard");
    if (widget.event != null) {
      final event = widget.event!;
      titleController.text = event.title;
      venueController.text = event.venue;
      descriptionController.text = event.description;


      selectedDate = event.startDateTime;
      selectedStartTime = TimeOfDay.fromDateTime(event.startDateTime);
      selectedEndTime = TimeOfDay.fromDateTime(event.endDateTime);

      selectedBoard = event.board;
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
                TextField(
                  controller: TextEditingController(text: selectedBoard),
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
                DropdownButtonFormField<String>(
                  value: selectedClub,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'Board',
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
                  items: clubs
                      .map((board) => DropdownMenuItem(
                      value: board,
                      child: Text(board,
                          style:
                          const TextStyle(color: Colors.white))))
                      .toList(),
                  onChanged: (value) {

                    if(value!=null){
                      setState(() {
                      selectedClub = value;
                    });}
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.arrow_drop_down,
                        color: Color(0xFFA2ACC0)),
                  ),
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

                          venueController.text.isNotEmpty &&
                          selectedDate != null &&
                          selectedStartTime != null &&
                          selectedEndTime != null ) {

                        if (widget.event == null) {
                          if (uploadedFilePath != null) {
                            _submitForm();
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in all required fields.')),);
                          }
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
        print("selectedEndTime =>>$selectedEndTime");
      });
    }
  }


  // Submit Form Method
  Future<void> _submitForm() async {
    var fileName = uploadedFilePath!.split('/').last;
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(uploadedFilePath!, filename: fileName),
      'title': titleController.text,
      'description': descriptionController.text,
      'club_org': selectedClub,
      'startDateTime': _formatDateTime(selectedDate!, selectedStartTime!),
      'endDateTime': _formatDateTime(selectedDate!, selectedEndTime!),
      'venue': venueController.text,
      'categories': <String>["$selectedBoard", "All"],
      'board': selectedBoard,
    });

    Map<String, dynamic> res = {};

    // Show the loading dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: const Color(0xFF273141),
          title: Text('Uploading Event',style: MyFonts.w500.copyWith(color: kWhite),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text('Please wait...',style: MyFonts.w300.copyWith(color: kWhite3),),
            ],
          ),
        );
      },
    );

    try {
      log("Uploading to server");
      res = await APIService().postEvent(formData);
    } catch (e) {
      print(e.toString());
    }

    // Hide the loading dialog
    Navigator.of(context).pop();

    if (res['saved_successfully']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event submitted successfully!')),
      );

      // Navigate back to the previous screen after success
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
      'club_org': selectedClub,
      'startDateTime': _formatDateTime(selectedDate!, selectedStartTime!),
      'endDateTime': _formatDateTime(selectedDate!, selectedEndTime!),
      'venue': venueController.text,
      'categories': widget.event!.categories,
      'board': selectedBoard,
      'file': uploadedFilePath != null
          ? (await MultipartFile.fromFile(uploadedFilePath!))
          : null,
      'imageURL': uploadedFilePath == null ? widget.event!.imageUrl : null,
      'compressedImageURL': uploadedFilePath == null
          ? widget.event!.compressedImageUrl
          : null,
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return  AlertDialog(
          backgroundColor: const Color(0xFF273141),
          title: Text('Updating Event',style: MyFonts.w500.copyWith(color: kWhite),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text('Please wait...',style: MyFonts.w300.copyWith(color: kWhite3),),
            ],
          ),
        );
      },
    );

    try {
      // Send the request to update the event
      res = await APIService().putEvent(widget.event!.id, formData);

      // Hide the loading dialog after the event is updated
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

     // await Future.delayed(const Duration(seconds: 2));

      // Pop the current screen and go back to the previous one
      Navigator.of(context).pop();
    } catch (e) {
      // Hide the loading dialog if an error occurs
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some unknown error occurred!')),
      );
    }
  }


 /* Future<void> _editForm() async {
    var res = {};
    final formData = FormData.fromMap({
      'title': titleController.text,
      'description': descriptionController.text,
      'club_org': selectedClub,
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
  }*/
}


String _formatDateTime(DateTime selectedDate, TimeOfDay time) {
  final formattedDate = selectedDate.copyWith(hour: time.hour, minute:  time.minute
  );
  return formattedDate.toUtc().toString();
}
