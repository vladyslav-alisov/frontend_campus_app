import 'package:flutter/material.dart';

const LargeTextSize = 25.0;
const MediumTextSize = 20.0;
const BodyTextSize = 15.0;
const MinTextSize = 12.0;

const mainColor = Color(0xFF102255);

const String FontNameDefault = 'ArialRounded';

final ThemeData appTheme = ThemeData(


  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: LargeTextSize,
    ),
    headline2: TextStyle(
      color: mainColor,
      fontSize: BodyTextSize,
    ),
    bodyText1: TextStyle(
      color: mainColor,
      fontSize: MinTextSize,
    ),
  ),
  primaryColor: mainColor,
  fontFamily: FontNameDefault,
);
