import 'package:cab_sharing/cab_sharing.dart';
import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';

class CabShare extends StatelessWidget {
  static const String id = "/cab_ola";
  const CabShare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(LoginStore.userData);
    return CabSharingScreen(userData: {
      'name': LoginStore.userData["name"]!,
      'email': LoginStore.userData["outlookEmail"]!,
      'security-key': const String.fromEnvironment('SECURITY-KEY')
    });
  }
}
