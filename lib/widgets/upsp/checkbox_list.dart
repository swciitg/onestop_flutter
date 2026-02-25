import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

class RadioButtonList extends StatefulWidget {
  const RadioButtonList({super.key, required this.values, required this.controller});
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.values.length,
      separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
      itemBuilder: (context, i) {
        final isSelected = widget.controller.selectedItem == widget.values[i];
        return GestureDetector(
          onTap: () => widget.controller.selectItem(widget.values[i]),
          child: Container(
            padding: const EdgeInsets.all(OSpacing.m),
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: BorderRadius.circular(OCornerRadius.l),
              border: Border.all(color: OColor.gray200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.values[i],
                    style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                  ),
                ),
                _ToggleBox(isSelected: isSelected),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom toggle checkbox matching Figma design:
/// 24×24 rounded-8 box, gray500 border when off, green600 fill when on.
class _ToggleBox extends StatelessWidget {
  final bool isSelected;
  const _ToggleBox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(OCornerRadius.s),
        border: Border.all(color: OColor.gray500),
      ),
      padding: const EdgeInsets.all(2),
      child:
          isSelected
              ? Container(
                decoration: BoxDecoration(
                  color: OColor.green600,
                  borderRadius: BorderRadius.circular(6),
                ),
              )
              : null,
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
