import 'package:flutter/material.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/services/api.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleEditOption() {
    //ADD functionality
    print('Edit option selected');
  }

  void _handleDeleteOption() {
    print('Delete option selected');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                print('Event deleted');
                var res;

                try {
                  res = APIService().deleteEvent(widget.event.id);
                } catch (e) {
                  print(e.toString());
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1b1d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF273141),
        title: Text(
          widget.event.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.event.imageURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (String result) {
                        if (result == 'edit') {
                          _handleEditOption();
                        } else if (result == 'delete') {
                          _handleDeleteOption();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  _buildEventDetail("Date",
                      "${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year}"),
                  const SizedBox(width: 5.0),
                  _buildEventDetail("Time",
                      "${widget.event.date.hour}:${widget.event.date.minute.toString().padLeft(2, '0')} - ${(widget.event.date.add(const Duration(hours: 1)).hour).toString().padLeft(2, '0')}:${widget.event.date.minute.toString().padLeft(2, '0')}"),
                ],
              ),
              _buildEventDetail("Venue", widget.event.venue),
              _buildEventDetail("Contact Details", widget.event.contactNumber),
              _buildEventDetail("Conducted by", widget.event.club_org),
              const SizedBox(height: 8.0),
              // Event Description
              Text(
                widget.event.description,
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              color: Color(0xFFA2ACC0),
              fontSize: 13,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(width: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
