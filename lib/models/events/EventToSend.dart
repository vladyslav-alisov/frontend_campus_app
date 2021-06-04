import 'dart:io';
import 'package:http/http.dart' as http;
class EventToSend {
  String title;
  String description;
  int attendee;
  String price;
  String date;
  String time;
  String location;
  File imageUrl;

  EventToSend(
      {
        this.title="",
        this.description="",
        this.attendee=0,
        this.price="",
        this.date="",
        this.time="",
        this.location="",
        this.imageUrl,
       });

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['attendee'] = this.attendee;
    data['price'] = this.price;
    data['date'] = this.date;
    data['time'] = this.time;
    data['location'] = this.location;
    data['imageUrl'] = imageUrl == null ? null : await http.MultipartFile.fromPath(
      'campusImage',
      this.imageUrl?.path,
    );

    return data;
  }

  @override
  String toString() {
    return '{"title": ${this.title}, "description": ${this.description}, "attendee": ${this.attendee}, "price": ${this.price}, "date": ${this.date}, "time": ${this.time}, "location": ${this.location}, "imageUrl": ${this.imageUrl}}';
  }
}