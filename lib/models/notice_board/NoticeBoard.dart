import 'dart:io';
import 'package:http/http.dart' as http;
class NoticeBoard {
  String sTypename;
  List<Notice> noticeList;

  NoticeBoard({this.sTypename, this.noticeList});

  NoticeBoard.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['noticeList'] != null) {
      noticeList = new List<Notice>();
      json['noticeList'].forEach((v) {
        noticeList.add(new Notice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.noticeList != null) {
      data['noticeList'] = this.noticeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"noticeList": ${this.noticeList}}';
  }
}

class Notice {
  String sTypename;
  String noticeID;
  String title;
  String description;
  String imageUrl;
  String creatorUserID;
  String creatorName;
  String creatorSurname;
  String phone;
  String email;
  String createdAt;

  Notice(
      {this.sTypename,
        this.noticeID,
        this.title,
        this.description,
        this.imageUrl,
        this.creatorUserID,
        this.creatorName,
        this.creatorSurname,
        this.phone,
        this.email,
        this.createdAt});

  Notice.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    noticeID = json['noticeID'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    creatorUserID = json['creatorUserID'];
    creatorName = json['creatorName'];
    creatorSurname = json['creatorSurname'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['noticeID'] = this.noticeID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] =  this.imageUrl;
    data['creatorUserID'] = this.creatorUserID;
    data['creatorName'] = this.creatorName;
    data['creatorSurname'] = this.creatorSurname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    return data;
  }
  @override
  String toString() {
    return '{"sTypename" :${this.sTypename},"noticeID" :${this.noticeID},"title" :${this.title},"description" :${this.description},"imageUrl" :${this.imageUrl},"creatorUserID": ${this.creatorUserID},"creatorName" :${this.creatorName},"creatorSurname" :${this.creatorSurname},"phone" :${this.phone},"email" :${this.email},"createdAt" :${this.createdAt}}';
  }
}