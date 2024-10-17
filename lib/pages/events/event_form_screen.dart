import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
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
  String? selectedClub;
  String? uploadedFilePath;

  // Controllers for text fields
  final titleController = TextEditingController();
  final venueController = TextEditingController();
  final contactNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      final event = widget.event!;
      titleController.text = event.title;
      venueController.text = event.venue;
      descriptionController.text = event.description;

      selectedDate = event.startDateTime;
      selectedStartTime = TimeOfDay.fromDateTime(event.startDateTime);
      selectedEndTime = TimeOfDay.fromDateTime(event.endDateTime);

      selectedBoard = event.board;
      selectedClub = event.clubOrg;
      //uploadedFilePath = event.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1b1d),
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : "Edit Event",
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF273141),
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
                    borderSide:
                        const BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 7),

              // Image Upload
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
              selectedBoard == null
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
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
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
                                  style: const TextStyle(color: Colors.white))))
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
                      //controller: titleController,
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
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1.0),
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

              // Dropdown for Club
              selectedClub == null
                  ? DropdownButtonFormField<String>(
                      value: selectedClub,
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF273141),
                        filled: true,
                        contentPadding: const EdgeInsets.only(left: 10),
                        labelText: 'Club/Organization *',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: const TextStyle(
                            color: Color(0xFFA2ACC0),
                            fontWeight: FontWeight.w400),
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
                      dropdownColor: const Color(0xFF273141),
                      items: ['Club A', 'Club B', 'Club C']
                          .map((club) => DropdownMenuItem(
                              value: club,
                              child: Text(club,
                                  style: const TextStyle(color: Colors.white))))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClub = value;
                        });
                      },
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.arrow_drop_down,
                            color: Color(0xFFA2ACC0)),
                      ),
                    )
                  : TextField(
                      //controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFF273141),
                        filled: true,
                        hintText: selectedClub,
                        hintStyle: const TextStyle(
                            color: Color(0xFFA2ACC0),
                            fontWeight: FontWeight.w400),
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
                      enabled: false,
                    ),

              const SizedBox(height: 7),

              // Date and Time Pickers
              _buildDateTimePickers(),

              const SizedBox(height: 7),

              // Contact Number
              TextField(
                controller: venueController,
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
                    borderSide:
                        const BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.blue, // Set the color of the icon
                  ),
                ),
              ),

              const SizedBox(height: 7),

              // Description
              TextField(
                controller: descriptionController,
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
                    borderSide:
                        const BorderSide(color: Color(0xFF273141), width: 1.0),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.event == null) {
                      _submitForm();
                    } else if (widget.event != null) {
                      _editForm();
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
      });
    }
  }

  //TODO change the form data
  // Submit Form Method
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
        const SnackBar(content: Text('Event submitted successfully!')),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EventFormScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some unknown error occurred!')),
      );
    }
  }

  Future<void> _editForm() async {
    var res = {};
    final formData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'club_org': selectedClub,
      'startDateTime': selectedDate,
      'endDateTime': selectedEndTime,
      'venue': venueController.text,
      'categories':widget.event!.categories, //TODO editable categories
      'board': selectedBoard,


       //TODO selected date and time format
    };
    if (uploadedFilePath == null) {
      formData['imageURL'] = widget.event!.imageUrl;
      formData['compressedImageURL']=widget.event!.compressedImageUrl;
    }
    if (uploadedFilePath != null && uploadedFilePath!.isNotEmpty) {
      formData['file'] = uploadedFilePath;                              //TODO attach image
    }

    try {
      res = await APIService().putEvent(widget.event!.id, formData);
    } catch (e) {
      print("Error updating event: $e");
    }

    if (res['updated_successfully'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );

      // Navigate to the relevant page or refresh the current screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EventFormScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some unknown error occurred!')),
      );
    }
  }
}
