import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/services/api.dart';

Future<void> showEventFormDialog(BuildContext context) async {
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedStartTime = pickedTime;
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      selectedEndTime = pickedTime;
    }
  }

  Future<void> _submitForm(BuildContext context) async {
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

    if (res['saved_successfully'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event submitted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some unknown error occurred!')),
      );
    }

    Navigator.of(context).pop();  // Close the dialog after form submission
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFF1b1b1d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
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
                      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                    if (result != null) {
                      uploadedFilePath = result.files.single.path;
                    }
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
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
                DropdownButtonFormField<String>(
                  value: selectedBoard,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF273141),
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    labelText: 'Board *',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: const TextStyle(
                        color: Color(0xFFA2ACC0), fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF273141), width: 1.0),
                    ),
                  ),
                  dropdownColor: const Color(0xFF273141),
                  items: const [
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
                          style: const TextStyle(color: Colors.white))))
                      .toList(),
                  onChanged: (value) {
                    selectedBoard = value;
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.arrow_drop_down,
                        color: Color(0xFFA2ACC0)),
                  ),
                ),
                const SizedBox(height: 7),
                // Other form fields similar to title and dropdown
                ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
