import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/event_form_screen.dart';
import 'package:onestop_dev/services/api.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final bool isAdmin;
  final VoidCallback? refresh;

  const EventDetailsScreen({Key? key, required this.event, required this.isAdmin, this.refresh}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {

  void _handleEditOption() {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFormScreen(event: widget.event)),
    );
    print('Edit option selected');
  }

  void _handleDeleteOption() {
    print('Delete option selected');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                print('Event deleted');
                var res;
                try {
                  res = APIService().deleteEvent(widget.event.id);
                 if(widget.isAdmin){
                  widget.refresh!();
                 }
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
    if(widget.isAdmin){
      assert(widget.refresh != null);
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1b1b1d),
      appBar: AppBar(
        backgroundColor: const Color(0xFF273141),
        title: Text(
          widget.event.title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,)),
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
                        widget.event.imageUrl??"",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if(widget.isAdmin)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,size: 20,color: kWhite,),
                          const SizedBox(width: 4,),
                          Text(DateFormat('dd/MM/yyyy').format(widget.event.startDateTime),style: MyFonts.w500.copyWith(color:kWhite),)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(Icons.location_on,size: 20,color: kWhite,),
                          const SizedBox(width: 4,),
                          Text(widget.event.venue,style: MyFonts.w500.copyWith(color:kWhite),)
                        ],
                      )

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled,size: 20,color: kWhite,),
                          const SizedBox(width: 4,),
                          Text("${DateFormat('hh:mm a').format(widget.event.startDateTime.toLocal())} - ${DateFormat('hh:mm a').format(widget.event.endDateTime.toLocal())}",style: MyFonts.w500.copyWith(color:kWhite),)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded,size: 20,color: kWhite,),
                          const SizedBox(width: 4,),
                          Text("${widget.event.clubOrg} Club",style: MyFonts.w500.copyWith(color:kWhite),)
                        ],
                      )

                    ],
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              // Event Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Text(
                  widget.event.description,
                  style: MyFonts.w500.copyWith(color: kWhite,fontSize: 15),
                ),
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
