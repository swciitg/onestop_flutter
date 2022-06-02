import 'package:flutter/material.dart';
import 'package:onestop_dev/globals/my_colors.dart';
import 'package:onestop_dev/globals/my_fonts.dart';

List<String> textdata = [
  'Open Start-> Control Panel -> Network and Internet-> Network and Sharing Center ',
  "Click on 'Manage wireless networks'",
  'Right click on \'Local area connection\' and then click on properties',
  'Uncheck \'Internet Protocol Version 6 (TCP/IPv6)\' and double click \'Internet Protocol Version 4 (TCP/IPv4)\'',
  'Select \'Use the following IP address\' and \'Use the following DNS server addresses\' Modify the DNS address as given below\nprimary DNS: 172.171.1.1\nsecondary DNS: 172.17.1.2',
  'Enter the following details to get your IP address',
  '',
  "Make sure the connection is no-proxy/direct connection. Open any website in your browser. It will show a captive portal asking your IITG login credentials.Login to the portal and start accessing internet using the same.If you have a problem while redirecting to login page, then use this link given below in your pc browser https://agnigarh.iitg.ac.in:1442/login?"
];

List<String> spinnerItems = [
  'Select Hostel',
  'Barak',
  'Umiam',
  'Brahmaputra',
  'Manas',
  'Dihing',
  'Dibang',
  'Married Scholars',
  'Siang',
  'Dhansiri',
  'Subhansiri',
  'Kapili',
  'Kameng'
];

decfunction(String x) {
  return InputDecoration(
    labelText: x,
    labelStyle: MyFonts.medium.setColor(kGrey7),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: kGrey7, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(
        color: kGrey7,
        width: 1,
      ),
    ),
  );
}
