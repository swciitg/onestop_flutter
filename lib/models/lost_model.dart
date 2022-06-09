import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LostModel{
  final String title;
  final String location;
  final String description;
  final String imageURL;
  final String compressedImageURL;
  final String phonenumber;
  final DateTime date;

  const LostModel({Key? key, required this.title, required this.description,required this.location,required this.imageURL,required this.compressedImageURL,required this.date,required this.phonenumber});
}
