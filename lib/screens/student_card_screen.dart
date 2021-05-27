import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentCardScreen extends StatelessWidget {
  static const routeName = '/student_card_screen';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialClubScreenController(),
      child: StudentCardScaffold(),
    );
  }
}

class StudentCardScaffold extends StatefulWidget {
  @override
  _StudentCardScaffoldState createState() => _StudentCardScaffoldState();
}

class _StudentCardScaffoldState extends State<StudentCardScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Comming soon..."),
      )
    );
  }
}
