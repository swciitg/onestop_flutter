import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/pages/buy_sell/buy_form.dart';
import 'package:onestop_dev/widgets/lostfound/new_page_button.dart';
import 'package:onestop_dev/widgets/lostfound/progress_bar.dart';
import 'package:onestop_kit/onestop_kit.dart';
import 'package:onestop_ui/index.dart';

class LostFoundLocationForm extends StatefulWidget {
  final String imageString;

  const LostFoundLocationForm({super.key, required this.imageString});

  @override
  State<LostFoundLocationForm> createState() => _LostFoundLocationFormState();
}

class _LostFoundLocationFormState extends State<LostFoundLocationForm> {
  String? selectedLocation;
  bool checkBox = false;
  String? selectedDropdown;
  List<String> libraries = ["Library", "Central library"];
  List<String> hostels = [
    "Hostel",
    ...Hostel.values.where((e) => e != Hostel.none).map((e) => e.displayString),
  ];
  List<String> sacs = ["SAC", "Old SAC", "New SAC"];
  List<String> cores = ["Core", "Core 1", "Core 2", "Core 3", "Core 4"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: OColor.gray100,
      appBar: AppBar(
        backgroundColor: OColor.gray100,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: OColor.gray800),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Submit at desk",
          style: OTextStyle.headingMedium.copyWith(color: OColor.gray800),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProgressBar(blue: 2, grey: 1),
          Padding(
            padding: const EdgeInsets.only(
              top: OSpacing.xl,
              left: OSpacing.m,
              right: OSpacing.m,
              bottom: OSpacing.m,
            ),
            child: Text(
              "Please submit the found item at your nearest security desk.",
              style: OTextStyle.bodyMedium.copyWith(color: OColor.gray600),
            ),
          ),
          // Checkbox row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: OSpacing.m),
            padding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
            decoration: BoxDecoration(
              color: OColor.white,
              borderRadius: BorderRadius.circular(OCornerRadius.m),
              border: Border.all(color: OColor.gray200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "I have submitted it",
                  style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
                ),
                Checkbox(
                  checkColor: OColor.white,
                  activeColor: OColor.green600,
                  side: BorderSide(color: OColor.gray400),
                  value: checkBox,
                  onChanged: (value) {
                    setState(() {
                      checkBox = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: OSpacing.m, top: OSpacing.l, bottom: OSpacing.s),
            child: Text(
              "Where did you submit it?",
              style: OTextStyle.labelMedium.copyWith(color: OColor.gray800),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: OSpacing.m),
              children: [
                _buildDropdown(label: "Library", items: libraries, groupKey: "Library"),
                const SizedBox(height: OSpacing.xs),
                _buildDropdown(label: "Hostel", items: hostels, groupKey: "Hostel"),
                const SizedBox(height: OSpacing.xs),
                _buildDropdown(label: "SAC", items: sacs, groupKey: "SAC"),
                const SizedBox(height: OSpacing.xs),
                _buildDropdown(label: "Core", items: cores, groupKey: "Core"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          if (checkBox == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Mark the checkbox if you have submitted the item",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                ),
              ),
            );
            return;
          }
          if (selectedLocation == null ||
              ["Library", "Hostel", "Core", "SAC"].contains(selectedLocation)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please select location of item submission",
                  style: OTextStyle.bodySmall.copyWith(color: OColor.white),
                ),
              ),
            );
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => BuySellForm(
                    category: "Found",
                    imageString: widget.imageString,
                    submittedAt: selectedLocation,
                  ),
            ),
          );
        },
        child: const NextButton(title: "Next"),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String groupKey,
  }) {
    final isSelected = selectedDropdown == groupKey;
    return DropdownButtonFormField<String>(
      initialValue: isSelected ? selectedLocation : items.first,
      icon: Icon(FluentIcons.chevron_down_24_regular, color: OColor.gray600),
      style: OTextStyle.bodyMedium.copyWith(color: OColor.gray800),
      dropdownColor: OColor.white,
      onChanged: (data) {
        setState(() {
          selectedLocation = data!;
          selectedDropdown = groupKey;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: OColor.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: OSpacing.m, vertical: OSpacing.s),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: OColor.green600, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OCornerRadius.m),
          borderSide: BorderSide(color: isSelected ? OColor.green600 : OColor.gray200, width: 1),
        ),
      ),
      items:
          items.map<DropdownMenuItem<String>>((String value) {
            final isHeader =
                value == items.first &&
                ![
                  "Central library",
                  "Old SAC",
                  "New SAC",
                  "Core 1",
                  "Core 2",
                  "Core 3",
                  "Core 4",
                ].contains(value);
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: OTextStyle.bodyMedium.copyWith(
                  color: isHeader ? OColor.gray400 : OColor.gray800,
                ),
              ),
            );
          }).toList(),
    );
  }
}
