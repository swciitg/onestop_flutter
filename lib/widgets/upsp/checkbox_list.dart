import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class CheckBoxList extends StatefulWidget {
  const CheckBoxList({Key? key, required this.values, required this.controller})
      : super(key: key);
  final List<String> values;
  final CheckBoxListController controller;
  @override
  State<CheckBoxList> createState() => _CheckBoxListState();
}

class _CheckBoxListState extends State<CheckBoxList> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.values.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            // value: committeeCheck[i],
            value: widget.controller.selectedItems.contains(widget.values[i]),
            checkColor: kGrey6,
            activeColor: lBlue2,
            // selected: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0), // Optionally
              side: const BorderSide(color: kGrey2),
            ),
            onChanged: (v) {
              if (widget.controller.selectedItems.contains(widget.values[i])) {
                widget.controller.removeItem(widget.values[i]);
              } else {
                widget.controller.addItem(widget.values[i]);
              }
            },
            title: Text(
              widget.values[i],
              style: MyFonts.w600.size(14).setColor(kWhite),
            ),
          ),
        );
      },
    );
  }
}

class CheckBoxListController extends ChangeNotifier {
  List<String> selectedItems = [];

  void addItem(String item) {
    selectedItems.add(item);
    notifyListeners();
  }

  void removeItem(String item) {
    selectedItems.remove(item);
    notifyListeners();
  }
}
