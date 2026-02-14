import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/buy_sell/sell_form.dart';
import 'package:onestop_ui/constants/corner_radius.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';

class PostAdSelection extends StatelessWidget {
  static const String id = "/postAdSelection";

  const PostAdSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            FluentIcons.arrow_left_24_regular,
            color: OColor.green600,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Post an Ad",
          style: OTextStyle.headingMedium.copyWith(
            color: OColor.gray800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           
           _OptionCard(
  icon: const SellRupeeIcon(),
  title: "Sell an item",
  description:
      "Have something you no longer need? List it here and connect with students looking to buy",
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SellItemForm(type: 'Sell',)),
    );
  },
),

            const SizedBox(height: 16),

          
           _OptionCard(
  icon: const SearchHelpIcon(),
  title: "Request an item",
  description:
      "Need an item? Request here and see if fellow students can offer what you need.",
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SellItemForm(type: 'Buy')),
    );
  },
),

          ],
        ),
      ),
    );
  }
}

class SellRupeeIcon extends StatelessWidget {
  const SellRupeeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: OColor.green600,
          width: 2,
        ),
      ),
      child:  Center(
        child: Icon(
          Icons.currency_rupee,
          size: 18,
          color: OColor.green600,
        ),
      ),
    );
  }
}


class SearchHelpIcon extends StatelessWidget {
  const SearchHelpIcon({super.key});
@override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: OColor.green600,
          width: 2,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              FluentIcons.search_24_regular,
              size: 23,
              color: OColor.green600,
            ),
            Positioned(
              bottom: 7,
              right: 7,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: OColor.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FluentIcons.question_16_regular,
                  size: 7,
                  color: OColor.green600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _OptionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OColor.white,
      borderRadius: BorderRadius.circular(OCornerRadius.l),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OCornerRadius.l),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: OColor.gray200),
            borderRadius: BorderRadius.circular(OCornerRadius.l),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Row(
                children: [
                  icon,
                  const SizedBox(width: 12),

                  Text(
                    title,
                    style: OTextStyle.labelLarge.copyWith(
                      color: OColor.gray800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    FluentIcons.chevron_right_24_regular,
                    size: 20,
                    color: OColor.gray600,
                  ),
                ],
              ),

              const SizedBox(height: 8),

             
              Text(
                description,
                style: OTextStyle.bodySmall.copyWith(
                  color: OColor.gray600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
