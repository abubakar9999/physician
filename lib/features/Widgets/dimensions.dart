import 'package:flutter/material.dart';

double height(context) {
  return MediaQuery.of(context).size.height;
}

double width(context) {
  return MediaQuery.of(context).size.width;
}

// double screenHeight(double height, BuildContext context) {
//   double size = 932 / height;
//   return MediaQuery.of(context).size.height / size;
// }

// double screenWidth(
//   double width,
//   BuildContext context,
// ) {
//   double size = 430 / width;
//   return MediaQuery.of(context).size.width / size;
// }

double screenHeight(double height, BuildContext context) {
  double size;
  if (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) {
    size = 932 / height;
  } else {
    size = 430 / height;
  }

  return MediaQuery.of(context).size.height / size;
}

double screenWidth(
    double width,
    BuildContext context,
    ) {
  double size;
  if (MediaQuery.of(context).size.height < MediaQuery.of(context).size.width) {
    size = 932 / width;
  } else {
    size = 430 / width;
  }
  return MediaQuery.of(context).size.width / size;
}

SizedBox heightSpace(double height, {Widget? child}) {
  return SizedBox(
    height: height,
    child: child,
  );
}

SizedBox widthSpace(double width, {Widget? child}) {
  return SizedBox(
    width: width,
    child: child,
  );
}