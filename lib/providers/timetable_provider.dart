import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/TimeTable.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }

class TimeTableProvider with ChangeNotifier {
  var setup = GraphQLSetup();

  AuthData authData;
  TimeTableProvider(this.authData);

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

  void resetVariables(){
    timeTable = null;
   mondayCourses = [];
   tuesdayCourses = [];
   wednesdayCourses = [];
   thursdayCourses = [];
   fridayCourses = [];
  }

  Future<void> timetable() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.timetable),
      variables: {
        ConstQueryKeys.userID: authData.login.userID,
        ConstQueryKeys.typeOfUser: authData.login.typeOfUser
      },
    );

    QueryResult result = await setup.client.value.query(options);

    if (result.hasException) {
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      resetVariables();
      timeTable = TimeTable.fromJson(result.data);
      if (timeTable != null) {
        separateCourses(timeTable.timetable.courseData);
      }
    }
    return result;
  }
}
