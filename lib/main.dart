import 'package:campus_app/providers/home.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/timeTable_screen.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          TimeTable.routeName: (context) => TimeTable(),
        },
      ),
    );
  }
}
