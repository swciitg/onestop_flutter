import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_ui/index.dart';

class PostAdChoice extends StatelessWidget {
  const PostAdChoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
        ),
        title: Text('Post an Ad', style: OTextStyle.headingMedium.copyWith(color: OColor.gray800)),
      ),
      body: Column(
        children: [
          Divider(height: 1, color: OColor.gray200),
          Padding(
            padding: const EdgeInsets.all(OSpacing.m),
            child: Column(
              children: [
                _ChoiceTile(
                  icon: FluentIcons.money_24_regular,
                  title: "Sell an item",
                  description: "List an item you want to sell to other students",
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const BuySellForm(category: "Sell")));
                  },
                ),
                const SizedBox(height: OSpacing.m),
                _ChoiceTile(
                  icon: FluentIcons.search_24_regular,
                  title: "Request an item",
                  description: "Post a request for an item you're looking to buy",
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const BuySellForm(category: "Buy")));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.m),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: OColor.green100,
                borderRadius: BorderRadius.circular(OCornerRadius.s),
              ),
              child: Icon(icon, color: OColor.green600, size: 20),
            ),
            const SizedBox(width: OSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
                  const SizedBox(height: OSpacing.xxs),
                  Text(description, style: OTextStyle.bodySmall.copyWith(color: OColor.gray600)),
                ],
              ),
            ),
            const SizedBox(width: OSpacing.xs),
            Icon(FluentIcons.chevron_right_24_regular, color: OColor.gray400, size: 20),
          ],
        ),
      ),
    );
  }
}
