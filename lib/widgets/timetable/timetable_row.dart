import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:onestop_dev/stores/timetable_store.dart';
import 'package:onestop_dev/widgets/ui/animated_expand.dart';
import 'package:provider/provider.dart';

class TimetableRow extends StatelessWidget {
  const TimetableRow({
    Key? key,
    required this.classes,
  }) : super(key: key);

  final List<Widget> classes;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return AnimatedExpand(
        expand: context.read<TimetableStore>().showDropDown,
        child: Column(
          children: classes
              .map((e) => Row(
                    children: [
                      const Expanded(
                        flex: 10,
                        child: SizedBox(),
                      ),
                      Expanded(flex: 36, child: e),
                      const SizedBox(
                        width: 8,
                      ),
                      const Expanded(flex: 7, child: SizedBox()),
                    ],
                  ))
              .toList(),
        ),
      );
      //return SizedBox();
    });
  }
}
