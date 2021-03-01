import 'package:campus_app/models/course.dart';
import 'package:flutter/material.dart';

class TimaTableList extends StatelessWidget {
  final int listLength;
  final List<Course> courses;

  TimaTableList({this.listLength,this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(

      itemCount: listLength,
      padding: EdgeInsets.only(bottom: 12,top: 12,left: 8,right: 8),
      separatorBuilder: (BuildContext context, int index) => Divider(height: 10,color: Colors.white,),
      itemBuilder: (context, index) => AspectRatio(
        aspectRatio: 398 / 160,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            border: Border.symmetric(),
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 19, bottom: 19, right: 19),
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
                      courses[index].courseTime ?? "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].coursePlace ?? "",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      courses[index].courseTeacher ?? "",
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
