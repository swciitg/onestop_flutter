import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/pages/events/events_screen_admin.dart';
import 'package:onestop_dev/services/api.dart';

class EventFormScreen extends StatefulWidget {
  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  String? selectedBoard;
  String? selectedClub;
  String? uploadedFilePath;

  // Controllers for text fields
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  final contactNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFF273141),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Custom width (80% of screen width)
            height: 370, // Custom height for the calendar dialog
            padding: EdgeInsets.all(10),
            child: Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  surface: Color(0xFF273141),
                  primary: Color(0xFFA2ACC0), // Header background color
                  onPrimary:
                      Color.fromARGB(255, 236, 241, 249), // Header text color
                  onSurface:
                      Color(0xFFA2ACC0), // Calendar body background color
                ),
                dialogBackgroundColor:
                    Color(0xFF273141), // Background color for the whole dialog
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: (DateTime date) {
                      Navigator.pop(context, date);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate as DateTime;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      barrierColor: Color(0xFF1b1b1d),
      context: context,
      initialTime:
          selectedStartTime ?? TimeOfDay.now(), // Default to current time
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFA2ACC0), // Set primary color
                onSurface: Color.fromARGB(255, 175, 176, 176),
                surface: Color(0xFF273141),
                secondary: Color(0xFFA2ACC0), // Set text color
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedStartTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      barrierColor: Color(0xFF1b1b1d),
      context: context,
      initialTime:
          selectedEndTime ?? TimeOfDay.now(), // Default to current time
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFA2ACC0), // Set primary color
                onSurface: Color.fromARGB(255, 175, 176, 176),
                surface: Color(0xFF273141),
                secondary: Color(0xFFA2ACC0), // Set text color
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedEndTime = pickedTime;
      });
    }
  }

  Future<void> _submitForm() async {
    var res = {};
    final formData = {
      'title': titleController.text,
      'uploadedPhoto': uploadedFilePath,
      'board': selectedBoard,
      'club': selectedClub,
      'date': selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
          : null,
      'venue': venueController.text,
      'startTime': selectedStartTime?.format(context),
      'endTime': selectedEndTime?.format(context),
      'contactNumber': contactNumberController.text,
      'description': descriptionController.text,
    };

    try {
      res = await APIService().postEvent(formData);
    } catch (e) {
      print(e.toString());
    }

    if (res['saved_successfully']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event submitted successfully!')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EventFormScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some unknown error occured!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1b1d),
      appBar: AppBar(
        title: const Text('Add Event',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF273141),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
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
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Color(0xFF273141),
                  filled: true,
                  hintText: 'Title *',
                  hintStyle: const TextStyle(
                      color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 7),
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
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
                    color: Color(0xFF273141),
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
                            style: TextStyle(
                              color: Color(0xFFA2ACC0),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.upload_sharp, color: Color(0xFFA2ACC0)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 7),
              DropdownButtonFormField<String>(
                value: selectedBoard,
                decoration: InputDecoration(
                  fillColor: Color(0xFF273141),
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Board *',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                      color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
                dropdownColor: Color(0xFF273141),
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
                        child:
                            Text(board, style: TextStyle(color: Colors.white))))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBoard = value;
                  });
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.arrow_drop_down, color: Color(0xFFA2ACC0)),
                ),
              ),
              SizedBox(height: 7),
              DropdownButtonFormField<String>(
                value: selectedClub,
                decoration: InputDecoration(
                  fillColor: Color(0xFF273141),
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Club/Organization *',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                      color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
                dropdownColor: Color(0xFF273141),
                items: ['Club A', 'Club B', 'Club C']
                    .map((club) => DropdownMenuItem(
                        value: club,
                        child:
                            Text(club, style: TextStyle(color: Colors.white))))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClub = value;
                  });
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.arrow_drop_down, color: Color(0xFFA2ACC0)),
                ),
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: 145,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFF273141),
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
                                  : Color(0xFFA2ACC0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: venueController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: Color(0xFF273141),
                        filled: true,
                        hintText: 'Venue *',
                        hintStyle: const TextStyle(
                            color: Color(0xFFA2ACC0),
                            fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Color(0xFF273141), width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectStartTime(context),
                      child: Container(
                        width: 145,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFF273141),
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
                                  : Color(0xFFA2ACC0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectEndTime(context),
                      child: Container(
                        width: 145,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Color(0xFF273141),
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
                                  : Color(0xFFA2ACC0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 7),
              TextField(
                controller: contactNumberController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Color(0xFF273141),
                  filled: true,
                  hintText: 'Contact Number *',
                  hintStyle: const TextStyle(
                      color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 7),
              TextField(
                controller: descriptionController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  fillColor: Color(0xFF273141),
                  filled: true,
                  hintText: 'Description',
                  hintStyle: const TextStyle(
                      color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit',
                      style: TextStyle(color: Color(0xFF00210B))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF76ACFF),
                    minimumSize: Size(double.infinity, 53),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
