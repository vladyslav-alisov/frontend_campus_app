import 'package:campus_app/models/Course%20dummy%20data.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/TimeTableList.dart';
import 'package:flutter/material.dart';
//todo add share button to appbar
class TimeTable extends StatelessWidget {
  static const String routeName = "/timeTable_screen";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.headline1,
            isScrollable: true,
            labelPadding: EdgeInsets.all(15),
            automaticIndicatorColorAdjustment: true,
            tabs: MyConstants.days,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: MyConstants.appBarColors,
              ),
            ),
          ),
          title: Text(
            MyConstants.funcTitles[0],
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: TabBarView(
          children: [
            TimaTableList(listLength: mondayCourses.length,courses: mondayCourses,),
            TimaTableList(listLength: tuesdayCourses.length,courses: tuesdayCourses,),
            TimaTableList(listLength: wednesdayCourses.length,courses: wednesdayCourses,),
            TimaTableList(listLength: thursdayCourses.length,courses: thursdayCourses,),
            TimaTableList(listLength: fridayCourses.length,courses: fridayCourses,),
          ],
        ),
      ),
    );
  }
}

