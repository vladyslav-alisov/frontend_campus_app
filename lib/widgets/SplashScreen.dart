import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1F3FF),
      body: Container(
        child: Center(
          child: Image.asset("assets/icons/IconCampusApp.png",fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
