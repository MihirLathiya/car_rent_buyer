import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class AppColors {
  static Color mainColor = Color(0xff2E7BD6);
  static Color white = Color(0xffffffff);
  static Color grey = Colors.grey;
  static Color yellow = Color(0xffFF971D);
  static Color black = Colors.black;
  static Color trans = Colors.transparent;
}

var height = Get.height;
var width = Get.width;
Widget loading() {
  return Center(
    child: Lottie.asset(
      'assets/images/lf30_editor_mhm0vq9q.json',
      height: 100,
      width: 100,
    ),
  );
}

Widget ImageLoading({String? url, double? height, double? width}) {
  return CachedNetworkImage(
    imageUrl: url!,
    height: height!,
    width: width,
    fit: BoxFit.cover,
    placeholder: (context, url) => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade300,
      child: Container(
        height: height,
        width: width!,
        color: Colors.grey.shade400,
      ),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

Widget BackDrop({Widget? child}) {
  return BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 2,
      sigmaY: 2,
    ),
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white12,
      ),
      child: child,
    ),
  );
}
