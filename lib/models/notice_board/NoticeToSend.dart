import 'dart:io';
import 'package:http/http.dart' as http;

class NoticeToSend {
  String title;
  String description;
  File image;
  String phone;
  String email;

  NoticeToSend({
    this.title,
    this.description,
    this.image,
    this.phone,
    this.email,
  });

  NoticeToSend.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = image == null
        ? null
        : await http.MultipartFile.fromPath(
            'campusImage',
            this.image?.path,
          );
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }

  @override
  String toString() {
    return '{"title" :${this.title},"description" :${this.description},"image" :${this.image},"phone" :${this.phone},"email" :${this.email}}';
  }
}
