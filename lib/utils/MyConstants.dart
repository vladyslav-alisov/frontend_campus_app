import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/menu_screens/menu_edit_screen.dart';
import 'package:campus_app/screens/menu_screens/menu_screen.dart';
import 'package:campus_app/screens/timeTable_screen.dart';
import 'package:flutter/material.dart';

class ConstMutation {
  static const String createMenu = '''
  mutation createMenu(\$menuInput: MenuInputData,\$userID: ID!){
  action: createMenu(menuInput: \$menuInput, userID:\$userID){
        dayID
        menuID
        redMeal
        day
        whiteMeal
        vegMeal
        soup
        salad
        dessert
      }
  }
  ''';
  static const String deleteEvent = '''
  mutation deleteEvent(\$eventID: ID!, \$userID: ID!){
  action: deleteEvent(eventID: \$eventID, userID: \$userID )
  }
  ''';

  static const String createEvent = '''
  mutation createEvent(\$eventInput: EventInputData!, \$userID: ID!){
  action: createEvent(eventInput: \$eventInput, userID: \$userID, ){
        eventID
        title
        description
        attendee
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

  static const String editEvent = '''
  mutation editEvent(\$eventInput: EventInputData!, \$userID: ID!, \$eventID: ID!){
  action: editEvent(eventInput: \$eventInput, userID: \$userID , eventID: \$eventID){
        eventID
        title
        description
        attendee
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
  static const String menu = '''
  query menu(){
          menu(){
              menuID
              dayID
              day
              redMeal
              whiteMeal
              vegMeal
              soup
              salad
              dessert
        }
  }
  ''';
  static const String listOfAttendees = '''
  query listOfAttendees(\$eventID: ID!, \$userID: ID!){
    listOfAttendees(eventID: \$eventID, userID: \$userID){
        count
        userID
        eventID
        name
        surname
        phone
        joinedAt
       }
    }
  ''';
  static const String hostEvents = '''
  query hostEvents(\$userID: ID!){
      hostEvents(userID: \$userID){
        eventID
        title
        description
        price
        attendee
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
  static const String myEvents = '''
  query myEvents(\$userID: ID!){
      myEvents(userID: \$userID){
        eventID
        title
        description
        price
        attendee
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
  static const String login = '''
  query login(\$email: String!, \$password: String!){
   login(email: \$email, password: \$password){
      email
      userID
      name 
      surname
      imageUrl
      typeOfUser
      socialClub
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
        day
        courseCode
        courseName
        time
        location
        lecturer
  }
}
  ''';

  static const String events = '''
  query events(\$userID: ID!){
    events(userID: \$userID){
        eventID
        title
        description
        price
        attendee
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
}

//for calling data we need key strings
class ConstQueryKeys {
  static const String eventInput = "eventInput";
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
  static const String title="title";
  static const String description="description";
  static const String attendee="attendee";
  static const String price="price";
  static const String date="date";
  static const String time="time";
  static const String location="location";
  static const String dayID = "dayID";
  static const String redMeal = "redMeal";
  static const String whiteMeal = "whiteMeal";
  static const String vegMeal = "vegMeal";
  static const String soup = "soup";
  static const String salad = "salad";
  static const String dessert = "dessert";
  static const String menuInput = "menuInput";
}

class ConstAssetsPath {
  static const img_placeHolder = 'assets/images/placeholderImage.png';
  static const img_loginImage = 'assets/images/LoginImage.png';
  static const img_studentCard = 'assets/images/Student Card.jpg';
  static const img_defaultAvatar = 'assets/images/defaultAvatar.jpeg';
  static const img_defaultEvent = 'assets/images/eventPlaceHolder.jpeg';
}

class MyConstants {
  static const List<String> assetStuffPaths = [
    'assets/images/Announcements.jpg',
    'assets/images/DinnerHall.jpg',
    'assets/images/Events.jpg',
    'assets/images/Transportation.jpg',
  ];

  static const List<String> routesStuff = [
    TimeTableScreen.routeName,
    MenuScreen.routeName,
    TimeTableScreen.routeName,
    TimeTableScreen.routeName,
  ];

  static const List<String> funcStuffTitles = [
    "Announcements",
    "Dinner Hall",
    "Events",
    "Transportation",
  ];

  static const List<Color> funcColorsStuff = [
    Color(0xFFFC7068),
    Color(0xFFFDD530),
    Color(0xFF4DAB57),
    Color(0xFF04D6A7),

  ];

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
    EventScreen.routeName,
    "/socialClub_screen",
    MenuScreen.routeName,
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

//default values for GraphQL
const str_noImage = "No Image";
const str_false = "false";
