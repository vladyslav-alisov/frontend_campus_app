import 'package:campus_app/utils/MyConstants.dart';

class AttendeeList {
  String sTypename;
  List<AttendeeData> attendees;

  AttendeeList({this.sTypename, this.attendees});

  AttendeeList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['listOfAttendees'] != null) {
      attendees = [];
      json['listOfAttendees'].forEach((v) {
        attendees.add(new AttendeeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.attendees != null) {
      data['attendees'] = this.attendees.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "listOfAttendees": ${this.attendees}}';
  }

}

class AttendeeData {
  String sTypename="";
  int count=0;
  String userID="";
  String eventID="";
  String name="";
  String surname="";
  int phone=0;
  String imageUrl;
  String joinedAt="";

  AttendeeData({
   this.sTypename,
   this.count,
   this.userID,
   this.eventID,
   this.name,
   this.surname,
   this.phone,
    this.imageUrl,
   this.joinedAt,
      });

  AttendeeData.fromJson(Map<String, dynamic> json) {
    sTypename = json["sTypename"];
    count = json["count"];
    userID = json["userID"];
    eventID = json["eventID"];
    name = json["name"];
    surname = json["surname"];
    phone = json["phone"];
    imageUrl = json["imageUrl"]!= null ? json["imageUrl"] : str_noImage;
    joinedAt = json["joinedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sTypename"]=this.sTypename;
    data["count"]=this.count;
    data["userID"]=this.userID;
    data["eventID"]=this.eventID;
    data["name"]=this.name;
    data["surname"]=this.surname;
    data["phone"]=this.phone;
    data["joinedAt"]=this.joinedAt;
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"count": ${this.count},"userID": ${this.userID},"eventID": ${this.eventID},"name": ${this.name},"surname": ${this.surname},"phone": ${this.phone},"joinedAt": ${this.joinedAt}}';
  }
}