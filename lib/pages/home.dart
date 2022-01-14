import 'package:flutter/material.dart';
import 'package:onestop_dev/stores/login_store.dart';
import 'package:provider/provider.dart';
import 'package:onestop_dev/widgets/appbar.dart';

class HomePage extends StatefulWidget {
  static String id = "/home";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${context.read<LoginStore>().userData['name']}',
            textAlign: TextAlign.center,
          ),
          Text(
            '${context.read<LoginStore>().userData['rollno']}',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<LoginStore>().logOut(context);
              },
              child: const Text('Log Out')),
        ],
      ),
    );
  }
}
