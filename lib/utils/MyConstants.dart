import 'package:flutter/material.dart';

class ConstMutation {
  static const String deleteEvent = '''
  mutation cancelEvent(\$eventID: ID!, \$userID: ID!){
  action: cancelEvent(eventID: \$eventID, userID: \$userID )
  }
  ''';

  static const String createEvent = '''
  mutation createEvent(\$eventInput: EventInputData!, \$userID: ID!){
  action: createEvent(eventInput: \$eventInput, userID: \$userID ){
        eventID
        title
        description
        atendee
        price
        organizer
        date
        time
        location
        imageUrl
        createdAt
        creator
    }
  }
  ''';

  static const String joinEvent = '''
  mutation joinEvent(\$eventID: ID!, \$userID: ID!){
  action: joinEvent(eventID: \$eventID, userID: \$userID ){
      userID
      eventID
      name
      surname
      phone
      joinedAt
    }
  }
  ''';

  static const String cancelEvent = '''
  mutation cancelEvent(\$eventID: ID!, \$userID: ID!){
  action: cancelEvent(eventID: \$eventID, userID: \$userID )
  }
  ''';
}

class ConstQuery {
  static const String hostEvents = '''
  query hostEvents(\$userID: ID!){
      hostEvents(userID: \$userID){
      events{
        eventID
        title
        description
        price
        atendee
        organizer
        date
        time
        location
        imageUrl
        createdAt
        creator
      }
    }
}
  ''';
  static const String myEvents = '''
  query myEvents(\$userID: ID!){
      myEvents(userID: \$userID){
      events{
        eventID
        title
        description
        price
        atendee
        organizer
        date
        time
        location
        imageUrl
        createdAt
        creator
      }
    }
}
  ''';
  static const String login = '''
  query login(\$email: String!, \$password: String!){
   login(email: \$email, password: \$password){
      email
      userID
      name 
      surname
      imageUrl
      typeOfUser
      sco
  }
}
  ''';

  static const String profile = '''
  query profile(\$userID: ID!,\$typeOfUser: String!){
   profile(userID: \$userID, typeOfUser:\$typeOfUser){
      userID
      name
      surname
      department
      email
      address
      phone
      balance
  }
}
  ''';

  static const String timetable = '''
  query timetable(\$userID: ID!,\$typeOfUser: String!){
   timetable(userID: \$userID, typeOfUser:\$typeOfUser){
      courseData{
        day
        courseCode
        courseName
        time
        location
        lecturer
      }
  }
}
  ''';

  static const String events = '''
  query events{
    events{
      events{
        eventID
        title
        description
        price
        atendee
        organizer
        date
        time
        location
        imageUrl
        createdAt
        creator
      }
    }
}
  ''';
}

//for calling data we need key strings
class ConstQueryKeys {
  static const String eventID = "eventID";
  static const String imageUrl = "imageUrl";
  static const String typeOfUser = "typeOfUser";
  static const String login = "login";
  static const String userID = "userID";
  static const String email = "email";
  static const String password = "password";
  static const String profile = "profile";
  static const String stdID = "stdID";
  static const String name = "name";
  static const String surname = "surname";
  static const String department = "department";
  static const String address = "address";
  static const String phone = "phone";
  static const String balance = "balance";
}

class ConstAssetsPath {
  static const img_placeHolder = 'assets/images/placeholderImage.png';
  static const img_loginImage = 'assets/images/LoginImage.png';
  static const img_studentCard = 'assets/images/Student Card.jpg';
  static const img_defaultAvatar = 'assets/images/defaultAvatar.jpeg';
  static const img_defaultEvent = 'assets/images/eventPlaceHolder.jpeg';
}

class MyConstants {
  static const List<String> assetPaths = [
    'assets/images/Announcements.jpg',
    'assets/images/Document Request.jpg',
    'assets/images/Student Card.jpg',
    'assets/images/TimeTable.jpg',
    'assets/images/Transportation.jpg',
    'assets/images/Events.jpg',
    'assets/images/SocialClubs.jpg',
    'assets/images/DinnerHall.jpg',
  ];
  static const List<String> routes = [
    "/timeTable_screen",
    "/home_screen",
    "/timeTable_screen",
    "/timeTable_screen",
    "/home_screen",
    "/event_screen",
    "/socialClub_screen",
    "/timeTable_screen",
  ];
  static const List<String> funcTitles = [
    "Announcements",
    "Document Request",
    "Student Card",
    "Time Table",
    "Transportation",
    "Events",
    "Social Clubs",
    "Dinner Hall",
  ];

  static const List<Text> days = [
    Text("Monday"),
    Text("Tuesday"),
    Text("Wednesday"),
    Text("Tuesday"),
    Text("Friday"),
  ];

  static const List<Color> appBarColors = [
    Color(0xFF102255),
    Color(0xFF2B799E),
    Color(0xFF40BDD6),
  ];

  static const List<Color> funcColors = [
    Color(0xFFFC7068),
    Color(0xFFFDC22E),
    Color(0xFF5198C1),
    Color(0xFF8562A5),
    Color(0xFF04D6A7),
    Color(0xFF4DAB57),
    Color(0xFF164F5F),
    Color(0xFFFDD530),
  ];
}

//login
const str_signIn = "Sign In";
const str_password = "Password";
const str_email = "E-mail";
const str_pleaseEnterYourEmail = "Please enter your academic e-mail address";
const str_pleaseEnterValidEmail = "Please enter valid e-mail";
const str_pleaseEnterYourPassword = "Please enter your password";
const str_yourPasswordWarningCharacters = "You password needs to be at least 6 characters long";
const str_hideMessage = "Hide Message";
const str_enterSomeText = "Please enter some text";

//profile_screen
const str_studentCardBalance = "Student Card Balance:";
const str_profile = "Profile";

//events_screens
const String myEvents = "My Events";
const String str_join = "Join";
const String str_search = "Search";
const String str_price = "Price";
const String str_myEvents = "My Events";
const String str_upcomingEvents = "Upcoming Events";
const String str_attending = "Attending";
const String str_seeAttendees = "See attendees";
const String str_cancel = "Cancel";
const String str_hosting = "Hosting";
const String str_warningBeforeLogOut = "Are you sure you want to exit?";
const String str_simpleWarning = "Are you sure?";
const String str_warningBeforeCancelEvent = "Are you sure you want to cancel event?";
const String str_logout = "Logout";
const String str_edit = "Edit";
const String str_createEvent = "Create Event";
const String str_delete = "Delete";
const String str_warningBeforeEventDelete = "Are you sure you want to delete event?";
const String str_yes= "Yes";
const String str_no= "No";
const String str_details = "Details";

//default values for vars
const str_noImage = "No Image";
