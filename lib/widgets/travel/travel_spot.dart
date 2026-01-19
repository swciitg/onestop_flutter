import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class SpotButton extends StatelessWidget {
  
  final String text ;
  final IconData icon ;

  const SpotButton({super.key, required this.text, required this.icon});


@override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () { 
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: OColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
              child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(
                          icon ,
                            color: OColor.green600,
                          size: 24,
                          ),
                          
                      const SizedBox(width: 12),
                      Expanded(
                          child: OText(
                            text: text,
                            style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                          ),
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: OColor.gray600,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                     margin: const EdgeInsets.symmetric(vertical: 2),
                       padding: const EdgeInsets.all(8),
                       decoration: BoxDecoration(
                        color: OColor.white,
                         borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: OColor.gray200),
                        ),
                     child: Image.asset(
                        'assets/images/map/travel_map.png',
                     ),
                    ),
                    const SizedBox(height: 24),
                    OText(
                      text:
                        "This travel guide covers the most commonly visited destinations, along with recommended routes and transport options to help you plan your journey smoothly.",
                    style: TextStyle(
                      fontSize: 14,
                        color: OColor.gray600,
                      height: 1.4,
                      ),
                        maxLines: 6,
                        overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 18),
                    const Divider(thickness: 1),
                    const SizedBox(height: 18),
                    
                    OText(
                      text: "Cab By",
                      textAlign: TextAlign.start,
                         style: OTextStyle.headingSmall.copyWith(color: OColor.black),
                      ),
                    const SizedBox(height: 4),
                    OText(
                      text: "Recommended for 4-7 people going together.",
                      textAlign: TextAlign.start,
                         style: TextStyle(
                      fontSize: 14,
                        color:OColor.gray600,
                      height: 1.4,
                      ),
                      ),
                    const SizedBox(height: 4),
                    OText(
                      text: "Go to this.\nGo to that\nNostrud eiusmod aliquip qui nulla ut anim sit laborum officia excepteur. Nostrud ad veniam id commodo cillum. Nisi ipsum anim deserunt culpa adipisicing proident consequat laboris enim nisi. Cillum veniam deserunt duis commodo.",
                    style: TextStyle(
                      fontSize: 14,
                        color:OColor.black,
                      height: 1.4,
                      ),
                        maxLines: 8,
                        overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                     margin: const EdgeInsets.symmetric(vertical: 2),
                       padding: const EdgeInsets.all(8),
                       decoration: BoxDecoration(
                        color: OColor.white,
                         borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: OColor.gray200),
                        ),
                        child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        OText(
                            text: "Cab Sharing",
                            style: OTextStyle.headingSmall.copyWith(color: OColor.green600),
                            ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_upward, 
                          color: OColor.green600),
                        ],
                          ),
                    ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(thickness: 1),
                    const SizedBox(height: 18),
                    OText(
                      text: "Cab By",
                      textAlign: TextAlign.start,
                         style: OTextStyle.headingSmall.copyWith(color: OColor.black),
                      ),
                    const SizedBox(height: 4),
                    OText(
                      text: "Recommended for 4-7 people going together.",
                         style: TextStyle(
                      fontSize: 14,
                        color:OColor.gray600,
                      height: 1.4,
                      ),
                      ),
                    const SizedBox(height: 4),
                     OText(
                      text: "Go to this.\nGo to that\nNostrud eiusmod aliquip qui nulla ut anim sit laborum officia excepteur. Nostrud ad veniam id commodo cillum. Nisi ipsum anim deserunt culpa adipisicing proident consequat laboris enim nisi. Cillum veniam deserunt duis commodo.",
                    style: TextStyle(
                      fontSize: 14,
                        color:OColor.black,
                      height: 1.4,
                      ),
                        maxLines: 8,
                        overflow: TextOverflow.fade,
                    ),
                ],
                  ),
              ),
              ),
            );
          },
        );
      },
      child: Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OColor.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon ,
                color: OColor.green600,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OText(
                  text: text,
                  style: OTextStyle.headingSmall.copyWith(color: OColor.black),
                  ),
              ),
              Icon(
                  FluentIcons.chevron_right_12_filled,
                  color: OColor.gray600,
                  size: 24,
                ) 
            ],
          ),
        ],
      ),
    ),
    );
  }
}
