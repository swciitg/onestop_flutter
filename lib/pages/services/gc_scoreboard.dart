import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/scoreboard.dart';

class Scoreboard extends StatelessWidget {
  static const String id = "/gc_score_board";
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GCScoreBoard(userInfo: {"name": LoginStore.userData["name"],"rollno": LoginStore.userData["rollNo"],"email" : LoginStore.userData["outlookEmail"]});
  }
}
