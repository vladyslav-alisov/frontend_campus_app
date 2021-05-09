import 'package:campus_app/models/TimeTable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CampusTimeTableListTile extends StatelessWidget {
  CampusTimeTableListTile(this._courseData);
  final List<CourseData> _courseData;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _courseData.length ?? 0,
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
        itemBuilder: (context, index) => Card(
              color: Color(0xff52C3DA),
              elevation: 7,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Column(
                      children: [
                        Text(
                          _courseData[index].time.split("-")[0],
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "-",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _courseData[index].time.split("-")[1],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.book,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                    _courseData[index].courseName ?? "",
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.chalkboardTeacher,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Text(
                                    _courseData[index].lecturer ?? "",
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.locationArrow,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 14,
                                  ),
                                  Text(_courseData[index].location ?? "")
                                ],
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
