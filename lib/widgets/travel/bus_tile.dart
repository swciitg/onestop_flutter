import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';

class BusTile extends StatelessWidget {
  final time;
  final isLeft;
  const BusTile({Key? key, required this.time, this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: const BoxDecoration(
          color: Color.fromRGBO(34, 36, 41, 1),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: ListTile(
        textColor: kWhite,
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(255, 227, 125, 1),
          radius: 20,
          child: Icon(
            IconData(0xe1d5, fontFamily: 'MaterialIcons',),
            color: kAppBarGrey,
          ),
        ),
        title: Text(time, style: const TextStyle(color: kWhite),),
        trailing: isLeft ?
        const Text('Left', style: TextStyle(color: kGrey11),) :
        const SizedBox(height: 0, width: 0,),
      ),
    );
  }
}
