import 'package:flutter/material.dart';

class BusTile extends StatelessWidget {
  final time;
  final isLeft;
  const BusTile({Key? key, required this.time, this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      //color: Colors.amberAccent,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(34, 36, 41, 1),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        textColor: Colors.white,
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 227, 125, 1),
          radius: 20,
          child: Icon(
            IconData(
              0xe1d5,
              fontFamily: 'MaterialIcons',
            ),
            color: Color.fromRGBO(39, 49, 65, 1),
          ),
        ),
        title: Text(
          time,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        ),
        trailing: isLeft
            ? const Text(
          'Left',
          style: TextStyle(color: Color.fromRGBO(135, 145, 165, 1)),
        )
            : const SizedBox(
          height: 0,
          width: 0,
        ),
      ),
    );
  }
}
