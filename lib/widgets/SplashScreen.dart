import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F3FF),
      body: Center(
        child: Image.asset("assets/icons/campusAppIcon.png"),
      ),
    );
  }
}
