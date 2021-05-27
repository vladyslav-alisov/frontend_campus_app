import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/events/AttendeeData.dart';
import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/models/events/EventToSend.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EventsProvider with ChangeNotifier {
  EventsProvider(this.authData, this.eventList, this.myEventList, this.hostEventList, this.attendeeList);

  final AuthData authData;

  List<Event> eventList = [];
  List<Event> myEventList = [];
  List<Event> hostEventList = [];
  List<AttendeeData> attendeeList = [];
  var setup = GraphQLSetup();

  //Event LISTS funcitons
  Future<void> events() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.events),
      variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.typeOfUser: authData.login.typeOfUser},
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      eventList = Events.fromJson(result.data).events;
    //  eventList.sort();
    }
    notifyListeners();
  }

  Future<void> myEvents() async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstQuery.myEvents), variables: {
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      myEventList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      print(myEventList);
      myEventList = MyEvents.fromJson(result.data).myEvents;
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
      print(result.exception);
      hostEventList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      hostEventList = HostEvents.fromJson(result.data).hostEvents;
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
      print(result.exception);
      throw "Could not cancel event! Please try again later.";
    } else {
      print(result.data);
      myEventList.removeWhere((element) => element.eventID == eventID);
    }
    notifyListeners();
  }

  Future<void> deleteEvent(String eventID) async {
    print(eventID);
    print(authData.login.userID);
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.deleteEvent), variables: {
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not delete event! Please try again.";
    } else {
      print(result.data);
      hostEventList.removeWhere((element) => element.eventID == eventID);
      eventList.removeWhere((element) => element.eventID == eventID);
    }
    notifyListeners();
  }

  Future<void> joinEvent(String eventID) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.joinEvent), variables: {
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.typeOfUser: authData.login.typeOfUser,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not join event! Please try again later.";
    } else {
      print(result.data);
      myEventList.add(eventList.firstWhere((element) => element.eventID == eventID));
    }
    notifyListeners();
  }

  Future<void> createEvent(EventToSend event) async {
    //todo: check if fetch polict cache it adds event in my events after creation
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: gql(ConstMutation.createEvent),
        variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.eventInput: await event.toJson()});
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not create an event! Please try again later.";
    } else {
      print(result.data);
      eventList.add(Event.fromJson(result.data["action"]));
    }
    notifyListeners();
  }

  Future<void> editEvent({String eventID, EventToSend event}) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.editEvent), variables: {
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.eventID: eventID,
      ConstQueryKeys.eventInput: await event.toJson(),
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not update an event! Please try again later.";
    } else {
      eventList[eventList.indexWhere((element) => element.eventID == eventID)] = Event.fromJson(result.data["action"]);
      if (hostEventList.isNotEmpty) {
        hostEventList[hostEventList.indexWhere((element) => element.eventID == eventID)] =
            Event.fromJson(result.data["action"]);
      }
    }
    notifyListeners();
  }

  Future<void> listOfAttendees(String eventID) async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.listOfAttendees),
      variables: {ConstQueryKeys.eventID: eventID},
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      print(result.data);
      attendeeList = AttendeeList.fromJson(result.data).attendees;
    }
    notifyListeners();
  }
}
