import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onestop_dev/functions/ip/ip_calculator.dart';
import 'package:onestop_dev/widgets/ip/ip_values.dart';

class IpPage extends StatefulWidget {
  final HostelDetails argso;
  const IpPage({Key? key, required this.argso}) : super(key: key);

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  List _items = [];
  // ignore: prefer_typing_uninitialized_variables
  var hostel;
  late HostelDetails args;
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/globals/ip.json');
    final data = await json.decode(response);
    setState(() {
      args = widget.argso;
      _items = data["Hostels"];
      for (var item in _items) {
        if (item["Hostel"] == args.hostelName) {
          hostel = item;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    String gateway;
    String subnet;
    String ipAdress;

    if (hostel == null) {
      subnet = "255.255.255.255";
      ipAdress = " macfe";
      gateway = "evadiki telsu";
    } else {
      gateway = hostel["Default Gateway"];
      subnet = hostel["Subnet mask"];
      ipAdress = hostel["IP Adress Range"];
      int k = 0;
      for (int i = 0; i < ipAdress.length; i++) {
        if (ipAdress[i] == '.') {
          k++;
          if (k == 2) {
            k = i;
            break;
          }
        }
      }
      ipAdress = calculatedetails(args, ipAdress.substring(0, k));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const IpValues(text: 'Your details:'),
        IpValues(text: 'Gateway: $gateway'),
        IpValues(text: 'Subnet: $subnet'),
        IpValues(text: 'IP Address: $ipAdress'),
      ],
    );
  }
}
