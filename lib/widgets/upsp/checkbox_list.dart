import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';
import 'package:onestop_kit/onestop_kit.dart';

class RadioButtonList extends StatefulWidget {
  const RadioButtonList({
    Key? key,
    required this.values,
    required this.controller,
  }) : super(key: key);
  final List<String> values;
  final RadioButtonListController controller;

  @override
  State<RadioButtonList> createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
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
          child: RadioListTile<String>(
            controlAffinity: ListTileControlAffinity.leading,
            value: widget.values[i],
            groupValue: widget.controller.selectedItem,
            activeColor: lBlue2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: const BorderSide(color: kGrey2),
            ),
            onChanged: (v) {
              widget.controller.selectItem(v!);
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

class RadioButtonListController extends ChangeNotifier {
  String? selectedItem;

  void selectItem(String item) {
    selectedItem = item;
    notifyListeners();
  }

  void clearSelection() {
    selectedItem = null;
    notifyListeners();
  }
}
