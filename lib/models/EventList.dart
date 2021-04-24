class EventList {
  String sTypename;
  Events events;

  EventList({this.sTypename, this.events});

  EventList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    events =
    json['events'] != null ? new Events.fromJson(json['events']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.events != null) {
      data['events'] = this.events.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"events": ${this.events}}';
  }
}
class MyEventList {
  String sTypename;
  Events myEvents;

  MyEventList({this.sTypename, this.myEvents});

  MyEventList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    myEvents =
    json['myEvents'] != null ? new Events.fromJson(json['myEvents']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.myEvents != null) {
      data['myEvents'] = this.myEvents.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"myEvents": ${this.myEvents}}';
  }
}

class HostEventList {
  String sTypename;
  Events hostEvents;

  HostEventList({this.sTypename, this.hostEvents});

  HostEventList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    hostEvents =
    json['hostEvents'] != null ? new Events.fromJson(json['hostEvents']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.hostEvents != null) {
      data['hostEvents'] = this.hostEvents.toJson();
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
  String atendee="";
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
        this.atendee,
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
    atendee = json['atendee'];
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
    data['atendee'] = this.atendee;
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
    return '{ "sTypename": ${this.sTypename}, "eventID": ${this.eventID}, "title": ${this.title}, "description": ${this.description}, "atendee": ${this.atendee}, "price": ${this.price}, "organizer": ${this.organizer}, "date": ${this.date}, "time": ${this.time}, "location": ${this.location}, "imageUrl": ${this.imageUrl}, "createdAt": ${this.createdAt}, "creator": ${this.creator}}';
  }
}
