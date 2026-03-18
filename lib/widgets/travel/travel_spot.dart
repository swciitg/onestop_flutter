import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/main.dart';
import 'package:onestop_dev/models/travel/travel_guide_model.dart';
import 'package:onestop_ui/index.dart';

import '../../pages/services/cab_share.dart';

class SpotButton extends StatelessWidget {
  final TravelGuideModel guide;
  final IconData icon;

  const SpotButton({super.key, required this.guide, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: OColor.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(top: 8, bottom: 16),
                            decoration: BoxDecoration(
                              color: OColor.gray200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Header row
                        Row(
                          children: [
                            Icon(icon, color: OColor.green600, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                guide.place,
                                style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: OColor.gray600),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        if (guide.description.isNotEmpty) ...[
                          Text(
                            guide.description,
                            style: OTextStyle.bodySmall.copyWith(
                              color: OColor.gray600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Transport methods
                        ...guide.transportMethods.asMap().entries.map((entry) {
                          final i = entry.key;
                          final method = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (i > 0) ...[const Divider(height: 32)],
                              Text(
                                method.method,
                                style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
                              ),
                              if (method.recommendation.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  method.recommendation,
                                  style: OTextStyle.bodySmall.copyWith(
                                    color: OColor.gray600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                              if (method.details.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  method.details,
                                  style: OTextStyle.bodySmall.copyWith(
                                    color: OColor.gray800,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                              if (method.hasCabSharing) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    navigatorKey.currentState?.pushNamed(CabShare.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: OColor.white,
                                      borderRadius: BorderRadius.circular(OCornerRadius.xl),
                                      border: Border.all(color: OColor.gray200),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Cab Sharing',
                                          style: OTextStyle.labelSmall.copyWith(
                                            color: OColor.green600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.arrow_outward, size: 14, color: OColor.green600),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        }),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Icon(icon, color: OColor.green600, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                guide.place,
                style: OTextStyle.headingSmall.copyWith(color: OColor.gray800),
              ),
            ),
            Icon(FluentIcons.chevron_right_12_filled, color: OColor.gray600, size: 24),
          ],
        ),
      ),
    );
  }
}
