class User {
  String sTypename;
  Profile profile;

  User({this.sTypename, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"profile": ${this.profile}}';
  }
}

class Profile {
  String sTypename;
  String userID;
  String name;
  String surname;
  String department;
  String email;
  String address;
  int phone;
  double balance;

  Profile(
      {this.sTypename,
        this.userID,
        this.name,
        this.surname,
        this.department,
        this.email,
        this.address,
        this.phone,
        this.balance});

  Profile.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    userID = json['userID'];
    name = json['name'];
    surname = json['surname'];
    department = json['department'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
    balance = json['balance'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['userID'] = this.userID;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['department'] = this.department;
    data['email'] = this.email;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['balance'] = this.balance;
    return data;
  }
  @override
  String toString() {

    return '{"sTypename": ${this.sTypename},"userID": ${this.userID},"name": ${this.name},"surname": ${this.surname},"department": ${this.department},"email": ${this.email},"address": ${this.address},"phone": ${this.phone},"balance ": ${this.balance}}';
  }
}