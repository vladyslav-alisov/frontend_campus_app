import 'package:flutter/material.dart';

const LargeTextSize = 25.0;
const MediumTextSize = 20.0;
const BodyTextSize = 15.0;
const MinTextSize = 12.0;

const mainColor = Color(0xFF102255);
const greyColor = Color(0xff696969);
const headColor = Color(0xFF464646);
const bodyColor = Color(0xFF696969);

const String FontNameDefault = 'ArialRounded';

final ThemeData appTheme = ThemeData(

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
      color: mainColor,
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
      color: bodyColor,
      fontSize: MinTextSize,
    ),
    bodyText2: TextStyle(
      color: Color(0xFF696969),
      fontSize: 15,
    ),
  ),
  primaryColor: mainColor,
  fontFamily: FontNameDefault,
);
