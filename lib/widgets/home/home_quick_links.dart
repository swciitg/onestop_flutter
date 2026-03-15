import 'dart:math';
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
      margin: const EdgeInsets.only(bottom: OSpacing.xs),
      padding: const EdgeInsets.all(OSpacing.m),
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
            // Title and description
            Expanded(
              child: OText(
                text: link.label,
                style: OTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: OColor.gray800,
                ),
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
