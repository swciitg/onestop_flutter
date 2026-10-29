import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

import 'sheet_header.dart';

/// Shows a list of options in a bottom sheet. [onChanged] is called with the
/// full selection on every toggle. With [multiSelect] false, tapping an option
/// selects it and closes the sheet.
Future<void> showDomainPickerSheet(
  BuildContext context, {
  required String title,
  IconData icon = FluentIcons.settings_32_regular,
  bool multiSelect = true,
  required List<String> options,
  required List<String> selected,
  required ValueChanged<List<String>> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: OColor.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (_) => _DomainPickerSheet(
      title: title,
      icon: icon,
      multiSelect: multiSelect,
      options: options,
      initial: selected,
      onChanged: onChanged,
    ),
  );
}

class _DomainPickerSheet extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool multiSelect;
  final List<String> options;
  final List<String> initial;
  final ValueChanged<List<String>> onChanged;

  const _DomainPickerSheet({
    required this.title,
    required this.icon,
    required this.multiSelect,
    required this.options,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<_DomainPickerSheet> createState() => _DomainPickerSheetState();
}

class _DomainPickerSheetState extends State<_DomainPickerSheet> {
  late final Set<String> _selected = {...widget.initial};

  void _toggle(String option) {
    setState(() {
      if (!widget.multiSelect) {
        _selected
          ..clear()
          ..add(option);
      } else if (!_selected.remove(option)) {
        _selected.add(option);
      }
    });
    // Keep the caller's ordering stable.
    widget.onChanged([
      for (final o in widget.options)
        if (_selected.contains(o)) o,
    ]);
    if (!widget.multiSelect) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: OSpacing.m,
          vertical: OSpacing.l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(
              icon: widget.icon,
              title: widget.title,
            ),
            const SizedBox(height: OSpacing.l),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (_, _) => const SizedBox(height: OSpacing.xs),
                itemBuilder: (_, i) {
                  final option = widget.options[i];
                  return _DomainTile(
                    label: option,
                    selected: _selected.contains(option),
                    onTap: () => _toggle(option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DomainTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DomainTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(OSpacing.m),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Expanded(
              child: OText(
                text: label,
                style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OColor.gray500),
              ),
              child:
                  selected
                      ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: OColor.green600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const SizedBox.expand(),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
