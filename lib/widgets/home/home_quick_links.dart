import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_ui/index.dart';

class HomeQuickLinks extends StatefulWidget {
  final List<HomeServiceTile> links;
  const HomeQuickLinks({super.key, required this.links});

  @override
  State<HomeQuickLinks> createState() => _HomeQuickLinksState();
}

class _HomeQuickLinksState extends State<HomeQuickLinks> {
  String _getDescription(String label) {
    // Provide descriptions based on the label
    switch (label.toLowerCase()) {
      case 'academic sso':
        return 'One login for all your academic needs. Courses, Moodle, grades, and more. Use your IITG ID to access everything in one place.';
      case 'placement stats':
        return 'Get the latest branch-wise placement statistics, top offers, and average packages.';
      case 'swc website':
        return 'Official website of Students\' Web Committee';
      case 'library':
        return 'Access digital resources, book catalog, and library services.';
      case 'hostel booking':
        return 'Book hostel rooms and manage accommodation requests.';
      case 'fee payment':
        return 'Pay semester fees, hostel fees, and other charges online.';
      case 'cab sharing':
        return 'Find and share cabs with fellow students for travel.';
      case 'lost and found':
        return 'Report lost items or find items reported by others.';
      default:
        return 'Quick access to essential services and information.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.links.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        OText(text: "Quick Links", style: OTextStyle.headingMedium),
        const SizedBox(height: 16),
        ...widget.links.map((link) => _buildQuickLinkItem(link)),
      ],
    );
  }

  Widget _buildQuickLinkItem(HomeServiceTile link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OColor.gray200),
        boxShadow: [
          BoxShadow(
            color: OColor.gray300.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Use the same tap logic as HomeServiceTile
          if (link.link != null) {
            link.launchURL(link.link!);
          } else {
            Navigator.pushNamed(context, link.routeId ?? "/");
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with green background circle
            Icon(Icons.link_rounded, color: OColor.green600, size: 20),
            const SizedBox(width: 16),
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OText(
                    text: link.label,
                    style: OTextStyle.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: OColor.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  OText(
                    text: _getDescription(link.label),
                    style: OTextStyle.bodySmall.copyWith(color: OColor.gray600, height: 1.4),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Transform.rotate(
              angle: -pi / 4,
              child: Icon(Icons.arrow_forward_rounded, color: OColor.gray400, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
