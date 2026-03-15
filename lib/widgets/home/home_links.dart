import 'package:flutter/material.dart';
import 'package:onestop_dev/widgets/home/home_tab_tile.dart';
import 'package:onestop_dev/widgets/home/service_links.dart';
import 'package:onestop_ui/index.dart';

class HomeQuickAccess extends StatefulWidget {
  const HomeQuickAccess({super.key});

  @override
  State<HomeQuickAccess> createState() => _HomeQuickAccessState();
}

class _HomeQuickAccessState extends State<HomeQuickAccess> with TickerProviderStateMixin {
  int activePageIndex = 0;
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  List<HomeServiceTile> serviceLinks =
      serviceLinksData.map((e) {
        final data = HomeServiceTileData.fromMap(e);
        return HomeServiceTile(
          label: data.label,
          icon: data.icon,
          routeId: data.routeId,
          newBadge: data.newBadge,
        );
      }).toList();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (serviceLinks.isEmpty) return const SizedBox();

    const int maxItemsToShow = 12;
    final bool shouldShowMoreButton = serviceLinks.length > maxItemsToShow;
    final List<HomeServiceTile> allwaysVisible = serviceLinks.take(maxItemsToShow).toList();
    final List<HomeServiceTile> remainingItems = serviceLinks.skip(maxItemsToShow).toList();
    final List<HomeServiceTile> visibleItems = isExpanded ? remainingItems : [];

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OText(text: "Quick Access", style: OTextStyle.headingMedium),
          const SizedBox(height: 16),
          _buildGrid(allwaysVisible),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _buildGrid(visibleItems),
          ),
          if (shouldShowMoreButton) ...[const SizedBox(height: 12), _buildShowMoreButton()],
        ],
      ),
    );
  }

  Widget _buildGrid(List<HomeServiceTile> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  Widget _buildShowMoreButton() {
    return Center(
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          return GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: OColor.gray300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OText(
                    text: isExpanded ? "Hide" : "Show More",
                    style: OTextStyle.bodyMedium.copyWith(
                      color: OColor.green600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down, color: OColor.green600, size: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
