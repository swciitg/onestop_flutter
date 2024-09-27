import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/pages/food/hostel_service.dart';
import 'package:onestop_dev/pages/food/mess_opi_form.dart';
import 'package:onestop_dev/pages/food/mess_subscription_change_form.dart';
import 'package:onestop_dev/widgets/food/mess/mess_link_tile.dart';
import 'package:onestop_kit/onestop_kit.dart';

class MessLinks extends StatelessWidget {
  const MessLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        //color: kAppBarGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mess Links',
            style: MyFonts.w600.size(18).setColor(kWhite),
          ),
          const SizedBox(height: 10),
          const Column(
            children: [
              MessLinkTile(
                label: "Mess Subscription Change",
                icon: Icons.food_bank_outlined,
                routeId: MessSubscriptionPage.id,
              ),
              const SizedBox(
                height: 10,
              ),
              MessLinkTile(
                label: "Mess OPI ",
                icon: Icons.edit_document,
                routeId: MessOpiFormPage.id,
              ),
              const SizedBox(
                height: 10,
              ),
              MessLinkTile(
                label: "Hostel Complaints",
                icon: Icons.article_outlined,
                routeId: HostelService.id,
              ),
            ],
          )
          /*GridView.count(
            crossAxisCount: 1,
            //childAspectRatio: 140 / 100,
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
                label: "Mess OPI ",
                icon: Icons.edit_document,
                routeId: MessOpiFormPage.id,
              ),
              MessLinkTile(
                label: "Hostel Services",
                icon: Icons.edit_document,
                routeId: HostelService.id,
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
