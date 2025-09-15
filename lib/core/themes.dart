// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

//--------------Settings Colors----------------------
const BACKGROUND_COLOR = Color(0xff2D2E3F);
const COLOR_PRIMARY = Color(0xff6F5A80);
const COLOR_SECONDARY = Color(0xff3E3548);
const COLOR_White = Colors.white;
const COLOR_Black = Colors.black;
const COLOR_Green1 = Color(0xff9DC284);
const COLOR_Grey = Color(0xFFBEC0BD);
const COLOR_Grey1 = Color(0xff545454);
const COLOR_Cyan1 = Color(0xff95C6C9);
const COLOR_Purple1 = Color(0xff4E2F53);
const COLOR_Purple2 = Color(0xffece8ef);
const COLOR_Amber1 = Colors.amber;

//--------------Action Panel Colors----------------------
const COLOR_Black1 = Color(0xff1E1E28);
const COLOR_Grey2 = Color(0xff3B3D52);
const COLOR_Grey3 = Color(0xff505470);
const COLOR_Blue1 = Color(0xff51508B);
const COLOR_OliveGreen = Color(0xff4B6962);
const COLOR_LightGreen = Color(0xff7AAEA2);
const COLOR_NavyBlue = Color(0xff3A51A3);
const COLOR_GreyBlue = Color(0xff5F5F82);
const COLOR_Green2 = Color(0xff46994E);
const COLOR_Red1 = Color(0xffC62C2C);
const COLOR_Red2 = Color(0xff7D3E3E);
const COLOR_LightPurple = Color(0xff6251A2);

const TEXTSTYLE_Headline4 =
    TextStyle(color: COLOR_White, fontWeight: FontWeight.w400, fontSize: 34);
const TEXTSTYLE_Headline5 =
    TextStyle(color: COLOR_White, fontWeight: FontWeight.w400, fontSize: 24);
const TEXTSTYLE_Headline6 =
    TextStyle(color: COLOR_White, fontWeight: FontWeight.w500, fontSize: 20);
const TEXTSTYLE_Headline18 =
    TextStyle(color: COLOR_White, fontWeight: FontWeight.w400, fontSize: 18);

const TEXTSTYLE_Headline13 =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 13);

DateTime getCurrentDateTime(String time) {
  return DateTime.parse(time);
}

ThemeData defaultTheme = ThemeData(
  useMaterial3: false,
  // backgroundColor: BACKGROUND_COLOR,
  // canvasColor: BACKGROUND_COLOR,
  // bottomNavigationBarTheme:
  //     const BottomNavigationBarThemeData(backgroundColor: COLOR_SECONDARY),
  // primaryColor: COLOR_PRIMARY,
  appBarTheme: const AppBarTheme(
    color: Color.fromARGB(255, 138, 201, 149),
    titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 27, 56, 34),
        fontWeight: FontWeight.w500,
        fontSize: 20),
  ),
  // drawerTheme:
  //     DrawerThemeData(backgroundColor: Color.fromARGB(255, 138, 201, 149))
  // bottomAppBarColor: COLOR_SECONDARY,
  // colorScheme: ColorScheme.light(
  //   primary: COLOR_PRIMARY,
  //   surface: COLOR_Grey2,
  // ),
  //drawerTheme: const DrawerThemeData(backgroundColor: COLOR_SECONDARY),
  // textTheme: const TextTheme(
  //   // bodyText2: TextStyle(

  //   //     ),
  //   headline1: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   headline2: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   headline3: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   headline4: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   headline5: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   headline6: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   subtitle1: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   subtitle2: TextStyle(
  //     color: COLOR_White,
  //   ),
  //   caption: TextStyle(
  //     color: COLOR_White,
  //   ),
  // ),
  // inputDecorationTheme: InputDecorationTheme(
  //   filled: true,
  //   fillColor: COLOR_White,
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(5.0),
  //   ),
  //   contentPadding: const EdgeInsets.all(10),
  // ),
  // listTileTheme: const ListTileThemeData(
  //   tileColor: COLOR_White,
  // ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     primary: COLOR_PRIMARY,
  //     elevation: 20,
  //   ),
  // ),
  // cardTheme: const CardTheme(
  //   color: Colors.transparent,
  //   elevation: 8,
  //   shadowColor: Colors.grey,
  // ),
  // dialogTheme: DialogTheme(
  //   backgroundColor: COLOR_SECONDARY,
  //   shape: RoundedRectangleBorder(
  //     side: const BorderSide(color: COLOR_White, width: 3),
  //     borderRadius: BorderRadius.circular(15),
  //   ),
  //   titleTextStyle: TEXTSTYLE_Headline5,
  // ),
  // timePickerTheme: const TimePickerThemeData(
  //   backgroundColor: BACKGROUND_COLOR,
  //   dialTextColor: COLOR_White,
  //   hourMinuteTextColor: COLOR_White,
  // ),
);
