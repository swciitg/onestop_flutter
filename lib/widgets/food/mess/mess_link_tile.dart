import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_dev/stores/login_store.dart';

class MessLinkTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? routeId;
  const MessLinkTile({
    super.key,
    required this.label,
    required this.icon,
    this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    final isGuest = LoginStore.isGuest;
    return Center(
      child: GestureDetector(
        onTap: () {
          if (!isGuest && routeId != null) {
            Navigator.pushNamed(context, routeId!);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: lGrey),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: lBlue,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                softWrap: true,
                textAlign: TextAlign.center,
                style: MyFonts.w500.size(14).setColor(lBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
