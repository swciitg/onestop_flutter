import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

void showBlurDialog(BuildContext context, List<String> images) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: height * 0.7,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: height * 0.7,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                    items: images.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
