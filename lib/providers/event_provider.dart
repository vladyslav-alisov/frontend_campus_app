import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/EventList.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventsProvider with ChangeNotifier {
  EventsProvider(this.authData, this.eventList, this.myEventList, this.hostEventList);

  final AuthData authData;

  List<Event> eventList = [];
  List<Event> myEventList = [];
  List<Event> hostEventList = [];
  var setup = GraphQLSetup();

  //Events funcitons
  Future<void> events() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql(ConstQuery.events),
    );

    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }

    if (result.data != null) {
      eventList = EventList.fromJson(result.data).events.events;
    }
    notifyListeners();
  }

  Future<void> myEvents() async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstQuery.myEvents), variables: {
      ConstQueryKeys.userID: authData.login.userID,
    });

    QueryResult result = await setup.client.value.query(options);

    print(result.data);
    if (result.hasException) {
      myEventList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      myEventList = MyEventList.fromJson(result.data).myEvents.events;
    }
    notifyListeners();
  }

  Future<void> hostEvents() async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstQuery.hostEvents), variables: {
      ConstQueryKeys.userID: authData.login.userID,
    });

    QueryResult result = await setup.client.value.query(options);

    if (result.hasException) {
      hostEventList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      hostEventList = HostEventList.fromJson(result.data).hostEvents.events;
    }
    notifyListeners();
  }

  Future<void> cancelEvent(String eventID) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.cancelEvent), variables: {
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.userID: authData.login.userID,
    });

    QueryResult result = await setup.client.value.mutate(options);

    if (result.hasException) {
      throw "Could not cancel event! Please try again later.";
    } else
      myEventList.removeWhere((element) => element.eventID == eventID);

    notifyListeners();
  }

  Future<void> deleteEvent(String eventID) async {
    print(hostEventList);
    print(eventID);
    print(authData.login.userID);
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.deleteEvent), variables: {
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.userID: authData.login.userID,
    });

    QueryResult result = await setup.client.value.mutate(options);

    print(result.exception);
    if (result.hasException) {
      throw "Could not delete event! Please try again.";
    } else {hostEventList.removeWhere((element) => element.eventID == eventID);}

    notifyListeners();
  }

  Future<void> joinEvent(String eventID) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.joinEvent), variables: {
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.userID: authData.login.userID,
    });

    QueryResult result = await setup.client.value.mutate(options);

    if (result.hasException) {
      print(result.exception);
      throw "Could not join event! Please try again later.";
    } else {
      print("Event added");
      myEventList.add(eventList.firstWhere((element) => element.eventID == eventID));
    }
    notifyListeners();
  }

  Future<void> createEvent(
   { String eventID,
    String title,
    String description,
    String atendee,
    String price,
    String date,
    String time,
    String location,
    String imageUrl,}
  ) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.createEvent), variables: {
      ConstQueryKeys.userID: authData.login.userID,
      "eventInput": {
        "title": title,
        "description": description,
        "atendee": atendee,
        "price": price,
        "date": date,
        "time": time,
        "location": location,
        "imageUrl": imageUrl,
      }
    });

    QueryResult result = await setup.client.value.mutate(options);

    print(result.data);
    print(result.exception);
    if (result.hasException) {
      //print(result.exception);
      throw "Could not create an event! Please try again later.";
    } else {
      print("Event successfully created");
      eventList.add(Event.fromJson(result.data));
    }
    notifyListeners();
  }
}
