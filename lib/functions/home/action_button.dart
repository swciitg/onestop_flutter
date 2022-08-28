import 'package:flutter/material.dart';
import 'package:onestop_dev/functions/timetable/show_dialog.dart';

Widget homeActionButton(BuildContext context, int index) {
  return (index == 3)
      ? FloatingActionButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
    onPressed: () {
      showMyDialog(context);
    },
    child: const Icon(Icons.add),
  )
      : const SizedBox();
}