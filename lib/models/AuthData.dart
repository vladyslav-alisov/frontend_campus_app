import 'package:campus_app/utils/MyConstants.dart';

class AuthData {
  String sTypename;
  Login login;

  AuthData({this.sTypename, this.login});

  AuthData.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    login = json['login'] != null ? new Login.fromJson(json['login']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.login != null) {
      data['login'] = this.login.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"login": ${this.login}}';
  }
}

class Login {
  String sTypename;
  String email;
  String phone;
  String userID;
  String name;
  String surname;
  String imageUrl;
  String typeOfUser;
  String socialClub;

  Login({
    this.sTypename,
    this.email,
    this.phone,
    this.userID,
    this.name,
    this.surname,
    this.imageUrl,
    this.typeOfUser,
    this.socialClub,
  });

  Login.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    email = json['email'];
    phone = json['phone'];
    userID = json['userID'];
    name = json['name'];
    surname = json['surname'];
    imageUrl = json['imageUrl'] != null ? json['imageUrl'] : str_noImage;
    typeOfUser = json['typeOfUser'];
    socialClub = json["socialClub"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['userID'] = this.userID;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['imageUrl'] = this.imageUrl;
    data['typeOfUser'] = this.typeOfUser;
    data['socialClub'] = this.socialClub;
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"email": ${this.email},"phone:" ${this.phone},userID": ${this.userID},"name": ${this.name},"surname": ${this.surname},"imageUrl": ${this.imageUrl},"typeOfUser": ${this.typeOfUser}, "socialClub": ${this.socialClub}';
  }
}
