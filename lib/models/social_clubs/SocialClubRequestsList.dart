class SocialClubRequestsList {
  String sTypename;
  List<SocialClubRequest> socialClubRequests;

  SocialClubRequestsList({this.sTypename, this.socialClubRequests});

  SocialClubRequestsList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['socialClubRequests'] != null) {
      socialClubRequests = new List<SocialClubRequest>();
      json['socialClubRequests'].forEach((v) {
        socialClubRequests.add(new SocialClubRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.socialClubRequests != null) {
      data['socialClubRequests'] =
          this.socialClubRequests.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "socialClubRequests": ${this.socialClubRequests}}';
  }
}

class SocialClubRequest {
  String sTypename;
  String userID;
  String name;
  String surname;
  String gender;
  String title;
  String department;
  String email;
  String address;
  int phone;
  String imageUrl;
  double balance;
  int semester;

  SocialClubRequest(
      {this.sTypename,
        this.userID,
        this.name,
        this.surname,
        this.gender,
        this.title,
        this.department,
        this.email,
        this.address,
        this.phone,
        this.imageUrl,
        this.balance,
        this.semester});

  SocialClubRequest.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    userID = json['userID'];
    name = json['name'];
    surname = json['surname'];
    gender = json['gender'];
    title = json['title'];
    department = json['department'];
    email = json['email'];
    address = json['address'];
    phone = json['phone'];
    imageUrl = json['imageUrl'];
    balance = json['balance'];
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['userID'] = this.userID;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['gender'] = this.gender;
    data['title'] = this.title;
    data['department'] = this.department;
    data['email'] = this.email;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['imageUrl'] = this.imageUrl;
    data['balance'] = this.balance;
    data['semester'] = this.semester;
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"userID": ${this.userID},"name": ${this.name},"surname": ${this.surname},"gender": ${this.gender},"title": ${this.title},"department": ${this.department},"email": ${this.email},"address": ${this.address},"phone": ${this.phone},"imageUrl": ${this.imageUrl},"balance": ${this.balance},"semester": ${this.semester}}';
  }
}