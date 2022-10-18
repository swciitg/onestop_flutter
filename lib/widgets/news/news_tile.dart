import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class NewsTile extends StatefulWidget {
  final String title;
  final String body;
  final String author;

  const NewsTile(
      {Key? key, required this.title, required this.body, required this.author})
      : super(key: key);

  @override
  State<NewsTile> createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title.trim(),
                style: MyFonts.w700
                    .setColor(kWhite)
                    .size(14)
                    .letterSpace(0.1)
                    .setHeight(1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                widget.body,
                style: MyFonts.w500
                    .setColor(kFontGrey)
                    .size(11)
                    .letterSpace(0.5)
                    .setHeight(1.2),
                maxLines: 15,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  widget.author,
                  style: MyFonts.w700.size(11).setColor(lBlue4),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1.5,
          color: kTabBar,
        ),
      ],
    );
  }
}
