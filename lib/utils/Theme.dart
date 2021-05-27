import 'package:flutter/material.dart';

const LargeTextSize = 25.0;
const MediumTextSize = 20.0;
const BodyTextSize = 15.0;
const MinTextSize = 12.0;

const mainColor = Color(0xFF102255);
const greyColor = Color(0xff696969);
const headColor = Color(0xFF464646);
const bodyColor = Color(0xFF696969);
const hintColor = Color(0xffD3D3D3);

const String FontNameDefault = 'ArialRounded';

final ThemeData appTheme = ThemeData(
  tabBarTheme: TabBarTheme(
    labelStyle: TextStyle(fontSize: 15, color: Colors.grey),
  ),
  hintColor: hintColor,
  appBarTheme: AppBarTheme(centerTitle: false, textTheme: TextTheme(headline1: TextStyle(fontSize: 30))),
  textButtonTheme: TextButtonThemeData(style: ButtonStyle()),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: LargeTextSize,
    ),
    headline2: TextStyle(
      color: mainColor,
      fontSize: BodyTextSize,
    ),
    headline3: TextStyle(
      color: greyColor,
      fontSize: MediumTextSize,
    ),
    headline4: TextStyle(
      color: Color(0xFF696969),
      fontSize: BodyTextSize,
    ),
    headline5: TextStyle(
      color: headColor,
      fontSize: MediumTextSize,
    ),
    bodyText1: TextStyle(
      color: Color(0xFF464646),
      fontSize: 13,
      fontWeight: FontWeight.w800
    ),
    bodyText2: TextStyle(
      color: Color(0xFF696969),
      fontSize: 13,
        fontWeight: FontWeight.w100

    ),
  ),
  primaryColor: mainColor,
  fontFamily: FontNameDefault,
);
