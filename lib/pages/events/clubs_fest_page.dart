import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Placeholder page for the Clubs/Fest section.
///
/// This will be replaced with actual content once the design and
/// API integration are ready.
class ClubsFestPage extends StatelessWidget {
  const ClubsFestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: OColor.green100,
                  borderRadius: BorderRadius.circular(OCornerRadius.l),
                ),
                child: Icon(
                  FluentIcons.people_community_24_regular,
                  size: 40,
                  color: OColor.green600,
                ),
              ),
              const SizedBox(height: OSpacing.m),
              OText(
                text: 'Clubs & Fests',
                style: OTextStyle.headingLarge.copyWith(
                  color: OColor.gray800,
                ),
              ),
              const SizedBox(height: OSpacing.s),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: OSpacing.xl),
                child: OText(
                  text: 'Explore clubs and fests happening around campus. Coming soon!',
                  style: OTextStyle.bodyMedium.copyWith(
                    color: OColor.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
