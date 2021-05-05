
class MyEvents {
  String sTypename;
  List<Event> myEvents;

  MyEvents({this.sTypename, this.myEvents});

  MyEvents.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['myEvents'] != null) {
      myEvents = [];
      json['myEvents'].forEach((v) {
        myEvents.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.myEvents != null) {
      data['myEvents'] = this.myEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"myEvents": ${this.myEvents}}';
  }
}

class HostEvents {
  String sTypename;
  List<Event> hostEvents;

  HostEvents({this.sTypename, this.hostEvents});

  HostEvents.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['hostEvents'] != null) {
      hostEvents = [];
      json['hostEvents'].forEach((v) {
        hostEvents.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.hostEvents != null) {
      data['hostEvents'] = this.hostEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"hostEvents": ${this.hostEvents}}';
  }
}

class Events {
  String sTypename;
  List<Event> events;

  Events({this.sTypename, this.events});

  Events.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['events'] != null) {
      events = [];
      json['events'].forEach((v) {
        events.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.events != null) {
      data['events'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "events": ${this.events}}';
  }

}

class Event {
  String sTypename="";
  String eventID="";
  String title="";
  String description="";
  String attendee="";
  String price="";
  String organizer="";
  String date="";
  String time="";
  String location="";
  String imageUrl="";
  String createdAt="";
  String creator="";

  Event(
      {this.sTypename,
        this.eventID,
        this.title,
        this.description,
        this.attendee,
        this.price,
        this.organizer,
        this.date,
        this.time,
        this.location,
        this.imageUrl,
        this.createdAt,
        this.creator});

  Event.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    eventID = json['eventID'];
    title = json['title'];
    description = json['description'];
    attendee = json['atendee'];
    price=json['price'];
    organizer = json['organizer'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    creator = json['creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['eventID'] = this.eventID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['atendee'] = this.attendee;
    data['price'] = this.price;
    data['organizer'] = this.organizer;
    data['date'] = this.date;
    data['time'] = this.time;
    data['location'] = this.location;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['creator'] = this.creator;
    return data;
  }

  @override
  String toString() {
    return '{ "sTypename": ${this.sTypename}, "eventID": ${this.eventID}, "title": ${this.title}, "description": ${this.description}, "atendee": ${this.attendee}, "price": ${this.price}, "organizer": ${this.organizer}, "date": ${this.date}, "time": ${this.time}, "location": ${this.location}, "imageUrl": ${this.imageUrl}, "createdAt": ${this.createdAt}, "creator": ${this.creator}}';
  }
}
