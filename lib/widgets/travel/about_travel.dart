import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';



class TravelGuideInfoCard extends StatelessWidget {
  const TravelGuideInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
              CircleAvatar(
                        backgroundColor: OColor.green100,
                          child: Icon(
                             FluentIcons.book_open_16_filled,
                            color: OColor.green600,
                            size: 24,
                          ),
                        ),
              const SizedBox(width: 12),
              Expanded(
                child: OText(
                  text: "About Travel Guide",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: OColor.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OText(
            text:
                "This travel guide covers the most commonly visited destinations, along with recommended routes and transport options to help you plan your journey smoothly.",
            style: TextStyle(
              fontSize: 14,
              color:OColor.black,
              height: 1.4,
            ),
            maxLines: 6,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}
