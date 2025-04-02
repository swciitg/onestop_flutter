import 'dart:developer';

import 'package:cab_sharing/cab_sharing.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';

class CabShare extends StatelessWidget {
  static const String id = "/cab_ola";
  const CabShare({super.key});

  @override
  Widget build(BuildContext context) {
    log("USERDATA: ${LoginStore.userData}");
    return CabSharingSplashScreen();
  }
}
