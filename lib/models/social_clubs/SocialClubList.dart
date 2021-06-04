class SocialClubList {
  String sTypename;
  List<SocialClub> socialClubs;

  SocialClubList({this.sTypename, this.socialClubs});

  SocialClubList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['socialClubs'] != null) {
      socialClubs = new List<SocialClub>();
      json['socialClubs'].forEach((v) {
        socialClubs.add(new SocialClub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.socialClubs != null) {
      data["socialClubs"] = this.socialClubs.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "socialClubs": ${this.socialClubs}}';
  }
}

class MySocialClubsList {
  String sTypename;
  List<SocialClub> socialClubs;

  MySocialClubsList({this.sTypename, this.socialClubs});

  MySocialClubsList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['mySocialClubs'] != null) {
      socialClubs = new List<SocialClub>();
      json['mySocialClubs'].forEach((v) {
        socialClubs.add(new SocialClub.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.socialClubs != null) {
      data['mySocialClubs'] = this.socialClubs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocialClub {
  String sTypename;
  String scID;
  String scoID;
  String title;
  String description;
  String imageUrl;
  int members;
  String status;

  SocialClub
      ({this.sTypename,
        this.scID,
        this.scoID,
        this.title,
        this.description,
        this.imageUrl,
        this.members,
      this.status});

  SocialClub.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    scID = json['scID'];
    scoID = json['scoID'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    members = json['members'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['scID'] = this.scID;
    data['scoID'] = this.scoID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['members'] = this.members;
    data['status'] = this.status;
    return data;
  }
  
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"scID": ${this.scID},"scoID": ${this.scoID},"title": ${this.title},"description": ${this.description},"imageUrl": ${this.imageUrl},"members": ${this.members}, "status": ${this.status}';
  }
}