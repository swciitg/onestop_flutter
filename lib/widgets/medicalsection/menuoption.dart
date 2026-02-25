import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/utils/colors.dart';
import 'package:onestop_ui/utils/styles.dart';
import 'package:onestop_ui/constants/corner_radius.dart';
import 'package:url_launcher/url_launcher.dart';

class Menuoption extends StatelessWidget {
  final String name;
  final Widget? navigationwidget;
  final String? link;
  final IconData? icon;

  const Menuoption({super.key, required this.name, this.navigationwidget, this.link, this.icon});

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(OCornerRadius.m),
      onTap: () {
        if (link != null) {
          launchURL(link!);
        } else if (navigationwidget != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => navigationwidget!));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OColor.green100,
                  borderRadius: BorderRadius.circular(OCornerRadius.s),
                ),
                child: Icon(icon, color: OColor.green600, size: 20),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(name, style: OTextStyle.labelMedium.copyWith(color: OColor.gray800)),
            ),
            Icon(FluentIcons.chevron_right_24_regular, color: OColor.gray400, size: 20),
          ],
        ),
      ),
    );
  }
}
