import 'dart:convert';

import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/TimeTable.dart';
import 'package:campus_app/utils/exception_handler.dart';
import 'package:campus_app/utils/graph_ql_setup.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }

class TimeTableProvider with ChangeNotifier {
  var setup = GraphQLSetup();

  AuthData authData;
  TimeTableProvider(
    this.authData,
    this.timeTable,
    this.mondayCourses,
    this.tuesdayCourses,
    this.wednesdayCourses,
    this.thursdayCourses,
    this.fridayCourses,
  );

  TimeTable timeTable;
  List<CourseData> mondayCourses = [];
  List<CourseData> tuesdayCourses = [];
  List<CourseData> wednesdayCourses = [];
  List<CourseData> thursdayCourses = [];
  List<CourseData> fridayCourses = [];

  void separateCourses(List<CourseData> lst) {
    if (lst != []) {
      lst.forEach((element) {
        if (element.day == describeEnum(Days.Monday)) {
          mondayCourses.add(element);
        }
      });
      lst.forEach((element) {
        if (element.day == describeEnum(Days.Tuesday)) {
          tuesdayCourses.add(element);
        }
      });
      lst.forEach((element) {
        if (element.day == describeEnum(Days.Wednesday)) {
          wednesdayCourses.add(element);
        }
      });
      lst.forEach((element) {
        if (element.day == describeEnum(Days.Thursday)) {
          thursdayCourses.add(element);
        }
      });
      lst.forEach((element) {
        if (element.day == describeEnum(Days.Friday)) {
          fridayCourses.add(element);
        }
      });
    }
  }

  void resetVariables() {
    timeTable = null;
    mondayCourses = [];
    tuesdayCourses = [];
    wednesdayCourses = [];
    thursdayCourses = [];
    fridayCourses = [];
  }

  Future<void> timetable() async {
    resetVariables();
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.timetable),
      variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.typeOfUser: authData.login.typeOfUser},
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      timeTable = TimeTable.fromJson(result.data);
      if (timeTable != null) {
        separateCourses(timeTable.timetable);
      }
    }
    return result;
  }
}
