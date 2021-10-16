import 'package:campus_app/utils/my_constants.dart';

class SocialClubMembersList {
  String sTypename;
  List<SocialClubMember> socialClubMembers;

  SocialClubMembersList({this.sTypename, this.socialClubMembers});

  SocialClubMembersList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['socialClubMembers'] != null) {
      socialClubMembers = new List<SocialClubMember>();
      json['socialClubMembers'].forEach((v) {
        socialClubMembers.add(new SocialClubMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.socialClubMembers != null) {
      data['socialClubMembers'] =
          this.socialClubMembers.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "socialClubMembers": ${this.socialClubMembers}}';
  }
}

class SocialClubMember {
  String sTypename;
  String userID;
  String name;
  String surname;
  String imageUrl;

  SocialClubMember({this.sTypename, this.userID, this.name, this.surname,this.imageUrl});

  SocialClubMember.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    userID = json['userID'];
    name = json['name'];
    surname = json['surname'];
    imageUrl = json['imageUrl'] != null ? json['imageUrl']: str_noImage;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['userID'] = this.userID;
    data['name'] = this.name;
    data['surname'] = this.surname;
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"userID": ${this.userID},"name": ${this.name},"surname": ${this.surname}, "imageUrl": ${this.imageUrl}';
  }
}