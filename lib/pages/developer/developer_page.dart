import 'package:flutter/material.dart';

import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/widgets/developer/developer_card.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/AppLogo.png',
        ),
        centerTitle: true,
        backgroundColor: kGrey14,
      ),
      body: Container(
        color: kBackground,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20,
            childAspectRatio: 0.64,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 50,
          ),
          children: List.filled(
            4,
            const DeveloperCard(
              developerAvatarPath: 'assets/images/profile_placeholder.png', //Replace with your own image
              developerName: 'Developer name', //Replace with your own name
              developerPosition: 'Developer position', //Replace with your own position
            ),
          ),
        ),
      ),
    );
  }
}