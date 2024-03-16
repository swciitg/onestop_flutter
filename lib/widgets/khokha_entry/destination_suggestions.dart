import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

class DestinationSuggestions extends StatelessWidget {
  final void Function(String) onChanged;
  final String selectedDestination;
  final List<String> destinationSuggestions;
  const DestinationSuggestions(
      {super.key, required this.onChanged, required this.selectedDestination, required this.destinationSuggestions,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Destination: ",
            style: MyFonts.w500.size(14).setColor(kWhite2),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              children: destinationSuggestions
                  .map(
                    (e) => GestureDetector(
                      onTap: (){
                        onChanged(e);
                      
                      },
                      child: buildDestinationChip(e, selectedDestination == e),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDestinationChip(String destination, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(360),
        color: selected ? lBlue2 : Colors.transparent,
        border: !selected ? Border.all(color: lBlue2, width: 1) : null,
      ),
      child: Text(
        destination,
        style: selected ? MyFonts.w500.size(14) : MyFonts.w500.size(14).setColor(lBlue2),
      ),
    );
  }
}
