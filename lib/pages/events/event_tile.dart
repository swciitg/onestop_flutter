import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/models/event_scheduler/event_model.dart';
import 'package:onestop_dev/pages/events/widgets/save_button.dart';

import 'event_form_screen.dart';

class EventTile extends StatelessWidget {
  final VoidCallback onTap;
  final EventModel model;
  final bool isAdmin;
  final VoidCallback? refresh;

  const EventTile(
      {Key? key,
      required this.onTap,
      required this.model,
      this.isAdmin = false, this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isAdmin){
      assert(refresh != null);
    }
    return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Card(
              color: const Color(0xFF273141),
              margin: const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            style: MyFonts.w700
                                .copyWith(color: kWhite2, fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            model.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: MyFonts.w500.copyWith(color: kWhite3),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_filled,
                                size: 12,
                                color: kWhite,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${DateFormat('hh:mm a').format(model.startDateTime.toLocal())} - ${DateFormat('hh:mm a').format(model.endDateTime.toLocal())}',
                                  style: MyFonts.w500
                                      .copyWith(color: kWhite3, fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 12,
                                color: kWhite,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  model.venue,
                                  style: MyFonts.w500.copyWith(color: kWhite3),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E4758),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 6.0),
                                child: Text(
                                  model.clubOrg,
                                  style: MyFonts.w500.copyWith(
                                      color: const Color(0xFF76ACFF),
                                      fontSize: 13),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                 const SizedBox(width:5),
                 if(model.compressedImageUrl != null) Expanded(
                    flex: 2, // Adjusting flex for a balanced layout
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: Image.network(
                        model.compressedImageUrl! ,
                        width: 140,
                        height: 150,
                        fit: BoxFit
                            .cover, // Ensures the image covers the entire area
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 150, // Adjust padding as needed
              child: isAdmin? InkWell(
                onTap: ()async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventFormScreen(event: model)),
                    );
                    if(isAdmin){
                      refresh!();
                    }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                     Icons.edit
                       ,
                    color: kWhite, //Color(0xFF76ACFF), // Color of the icon
                    size: 24, // Size of the icon
                  ),
                ),
              ): SaveButton(event: model),
            ),
          ],
        ));
  }
}
