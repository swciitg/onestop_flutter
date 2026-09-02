import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';
import 'package:shimmer/shimmer.dart';

/// Skeletal loading shimmer for the Events Homepage.
class EventsHomeShimmer extends StatelessWidget {
  const EventsHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Happening Today Shimmer
        _buildSectionHeaderShimmer(width: 140),
        const SizedBox(height: OSpacing.s),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: OSpacing.s),
            itemBuilder: (_, _) => const EventSmallCardShimmer(),
          ),
        ),
        const SizedBox(height: OSpacing.l),

        // 2. Trending Events Shimmer
        _buildSectionHeaderShimmer(width: 130),
        const SizedBox(height: OSpacing.s),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            itemCount: 2,
            separatorBuilder: (_, _) => const SizedBox(width: OSpacing.s),
            itemBuilder: (_, _) => const EventMediumCardShimmer(),
          ),
        ),
        const SizedBox(height: OSpacing.l),

        // 3. Your Interests Large Cards Shimmer
        _buildSectionHeaderShimmer(width: 120),
        const SizedBox(height: OSpacing.s),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
          child: Column(
            children: const [
              EventLargeCardShimmer(),
              SizedBox(height: OSpacing.s),
              EventLargeCardShimmer(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeaderShimmer({required double width}) {
    return Shimmer.fromColors(
      baseColor: OColor.gray200,
      highlightColor: OColor.gray100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: OColor.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: OSpacing.xs),
            Container(
              width: width,
              height: 18,
              decoration: BoxDecoration(
                color: OColor.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone shimmer matching [EventListingSmallCard].
class EventSmallCardShimmer extends StatelessWidget {
  const EventSmallCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358,
      padding: const EdgeInsets.all(OSpacing.s),
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      child: Shimmer.fromColors(
        baseColor: OColor.gray200,
        highlightColor: OColor.gray100,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: OColor.gray200,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: OSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone shimmer matching [EventListingMediumCard].
class EventMediumCardShimmer extends StatelessWidget {
  const EventMediumCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: OColor.gray200,
        highlightColor: OColor.gray100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner image shimmer
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: OColor.gray200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(OSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 160,
                    height: 14,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 16,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 50,
                        height: 16,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standalone shimmer matching [EventListingLargeCard].
class EventLargeCardShimmer extends StatelessWidget {
  const EventLargeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OColor.white,
        borderRadius: BorderRadius.circular(OCornerRadius.m),
        border: Border.all(color: OColor.gray200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: OColor.gray200,
        highlightColor: OColor.gray100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image banner
            AspectRatio(
              aspectRatio: 358 / 201,
              child: Container(
                color: OColor.gray200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(OSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    width: 240,
                    height: 18,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: OSpacing.s),
                  // Tags
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 70,
                        height: 20,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: OSpacing.s),
                  // Location / Date
                  Container(
                    width: 180,
                    height: 12,
                    decoration: BoxDecoration(
                      color: OColor.gray200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: OSpacing.s),
                  // Divider
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: OColor.gray200,
                  ),
                  const SizedBox(height: OSpacing.s),
                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 32,
                        decoration: BoxDecoration(
                          color: OColor.gray200,
                          borderRadius: BorderRadius.circular(OCornerRadius.s),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
