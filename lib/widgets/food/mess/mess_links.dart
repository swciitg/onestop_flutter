import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/mess_opi_form.dart';
import 'package:onestop_dev/pages/food/mess_subscription_change_form.dart';
import 'package:onestop_dev/widgets/food/mess/mess_link_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MessLinks extends StatelessWidget {
  const MessLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: kHomeTile,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mess Links',
            style: MyFonts.w600.size(14).setColor(kWhite),
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 140 / 100,
            shrinkWrap: true,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              MessLinkTile(
                label: "Mess Subscription Change",
                icon: Icons.food_bank_outlined,
                routeId: MessSubscriptionPage.id,
              ),
              MessLinkTile(
                label: "Mess OPI (Overall Performance Index)",
                icon: Icons.edit_document,
                routeId: MessOpiFormPage.id,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
