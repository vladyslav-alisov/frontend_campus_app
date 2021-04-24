import 'package:campus_app/models/TimeTable.dart';
import 'package:flutter/material.dart';

class TimeTableCards extends StatelessWidget {
  final List<CourseData> courses;

  TimeTableCards({this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: courses.length,
      padding: EdgeInsets.only(
        bottom: 12,
        top: 12,
        left: 8,
        right: 8,
      ),
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 10,
        color: Colors.white,
      ),
      itemBuilder: (context, index) => AspectRatio(
        aspectRatio: 398 / 160,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.symmetric(),
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 19,
                bottom: 19,
                right: 19,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].courseName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].time ?? "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].location ?? "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].lecturer ?? "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
