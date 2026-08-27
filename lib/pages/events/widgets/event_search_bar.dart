import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_ui/index.dart';

/// Search bar widget matching the Figma design with full typing, debouncing, and clearing support.
class EventSearchBar extends StatelessWidget {
  final String placeholder;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool isLoading;

  const EventSearchBar({
    super.key,
    this.placeholder = 'Search events by name, club or tags',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onClear,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEditable = controller != null || onChanged != null;

    return RepaintBoundary(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: OSpacing.s),
        decoration: BoxDecoration(
          color: OColor.white,
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          border: Border.all(color: OColor.gray200),
        ),
        child: Row(
          children: [
            Icon(
              FluentIcons.search_24_regular,
              size: 20,
              color: OColor.gray500,
            ),
            const SizedBox(width: OSpacing.xs),
            Expanded(
              child:
                  isEditable
                      ? TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        style: OTextStyle.labelMedium.copyWith(
                          color: OColor.gray800,
                        ),
                        cursorColor: OColor.green600,
                        decoration: InputDecoration(
                          hintText: placeholder,
                          hintStyle: OTextStyle.labelMedium.copyWith(
                            color: OColor.gray400,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      : GestureDetector(
                        onTap: onTap,
                        behavior: HitTestBehavior.opaque,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: OText(
                            text: placeholder,
                            style: OTextStyle.labelMedium.copyWith(
                              color: OColor.gray400,
                            ),
                          ),
                        ),
                      ),
            ),
            if (isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(OColor.green600),
                  ),
                ),
              )
            else if (controller != null && controller!.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  controller?.clear();
                  onClear?.call();
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    FluentIcons.dismiss_circle_24_filled,
                    size: 18,
                    color: OColor.gray400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
