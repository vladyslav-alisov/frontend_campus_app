class TimeTable {
  String sTypename;
  List<CourseData> timetable;

  TimeTable({this.sTypename, this.timetable});

  TimeTable.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['timetable'] != null) {
      timetable = [];
      json['timetable'].forEach((v) {
        timetable.add(new CourseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.timetable != null) {
      data['timetable'] = this.timetable.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"timetable": ${this.timetable}}';
  }
}

class CourseData {
  String sTypename;
  String day;
  String courseCode;
  String courseName;
  String time;
  String location;
  String lecturer;

  CourseData(
      {this.sTypename,
        this.day,
        this.courseCode,
        this.courseName,
        this.time,
        this.location,
        this.lecturer});

  CourseData.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    day = json['day'];
    courseCode = json['courseCode'];
    courseName = json['courseName'];
    time = json['time'];
    location = json['location'];
    lecturer = json['lecturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['day'] = this.day;
    data['courseCode'] = this.courseCode;
    data['courseName'] = this.courseName;
    data['time'] = this.time;
    data['location'] = this.location;
    data['lecturer'] = this.lecturer;
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"day": ${this.day},"courseCode": ${this.courseCode},"courseName": ${this.courseName},"time": ${this.time},"location": ${this.location},"lecturer": ${this.lecturer}}';
  }
}