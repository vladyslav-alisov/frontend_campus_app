import 'package:campus_app/screens/announcements_screens/announcements_screen.dart';
import 'package:campus_app/screens/dinner_hall_screens/dinner_hall.dart';
import 'package:campus_app/screens/document_request_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_screen.dart';
import 'package:campus_app/screens/student_card_screen.dart';
import 'package:campus_app/screens/time_table_screen.dart';
import 'package:campus_app/screens/transportation_screen.dart';
import 'package:flutter/material.dart';

class ConstMutation {


  static const String deletePost = '''
  mutation deletePost(\$postID: ID!, \$scoID: ID!){
  action: deletePost(postID: \$postID, scoID:\$scoID)
  }
  ''';
  static const String deleteAvatar = '''
  mutation deleteAvatar(\$userID: ID!,\$typeOfUser: String!){
  action: deleteAvatar(userID: \$userID, typeOfUser: \$typeOfUser)
  }
  ''';

  static const String chooseMeals = '''
  mutation chooseMeals(\$menuInput: MenuInputData!, \$userID: ID!){
  action: chooseMeals(menuInput: \$menuInput, userID: \$userID )
  }
  ''';
  static const String uploadAvatar = '''
  mutation uploadAvatar(\$image: Upload!,\$typeOfUser: String!, \$userID: ID!){
  action: uploadAvatar(image: \$image, typeOfUser:\$typeOfUser, userID:\$userID)
  }
  ''';

  static const String cancelRequestJoinSocialClub ='''
  mutation cancelRequestJoinSocialClub (\$userID: ID!, \$scID: ID!){
  action: cancelRequestJoinSocialClub (userID: \$userID,scID: \$scID )
  }
  ''';

  static const String acceptJoinSocialClub = '''
  mutation acceptJoinSocialClub(\$scID: ID!, \$scoID: ID!,\$userID: ID!){
  action: acceptJoinSocialClub(scID: \$scID, scoID: \$scoID, userID: \$userID){
        scID
        scoID
        title
        description
        imageUrl
        members
    }
  }
  ''';
  static const String denyJoinSocialClub = '''
  mutation denyJoinSocialClub(\$scID: ID!, \$scoID: ID!,\$userID: ID!){
  action: denyJoinSocialClub(scID: \$scID, scoID: \$scoID, userID: \$userID)
  }
  ''';

  static const String deleteSCMember = '''
  mutation deleteSCMember(\$scID: ID!, \$scoID: ID!,\$userID: ID!){
  action: deleteSCMember(scID: \$scID, scoID: \$scoID, userID: \$userID){
        scID
        scoID
        title
        description
        imageUrl
        members
    }
  }
  ''';
  static const String editDescriptionSocialClub = '''
  mutation editDescriptionSocialClub(\$scID: ID!, \$scoID: ID!,\$inputDescription: String!){
  action: editDescriptionSocialClub(scID: \$scID, scoID: \$scoID, inputDescription: \$inputDescription)
  }
  ''';
  static const String quitSocialClub = '''
  mutation quitSocialClub(\$scID: ID!, \$userID: ID!){
  action: quitSocialClub(scID: \$scID, userID: \$userID )
  }
  ''';
  static const String sendRequestJoinSocialClub = '''
  mutation sendRequestJoinSocialClub(\$userID: ID!, \$scID: ID!){
  action: sendRequestJoinSocialClub( userID: \$userID,scID: \$scID )
  }
  ''';

  static const String uploadPost = '''
  mutation uploadPost(\$postInput: PostInputData,\$scID: ID!, \$scoID: ID!){
  action: uploadPost(postInput: \$postInput, scID:\$scID, scoID:\$scoID){
       postID
       imageUrl
       description
       createdAt
    }
  }
  ''';

  static const String uploadAvatarSocialClub = '''
  mutation uploadAvatarSocialClub(\$image: Upload!,\$scID: ID!, \$userID: ID!){
  action: uploadAvatarSocialClub(image: \$image, scID:\$scID, userID:\$userID)
  }
  ''';

  static const String deleteAvatarSocialClub = '''
  mutation deleteAvatarSocialClub(\$scID: ID!, \$userID: ID!){
  action: deleteAvatarSocialClub(scID:\$scID, userID:\$userID)
  }
  ''';
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
  mutation joinEvent(\$eventID: ID!, \$userID: ID!,\$typeOfUser: String!){
  action: joinEvent(eventID: \$eventID, userID: \$userID, typeOfUser: \$typeOfUser){
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
  action: cancelEvent(eventID: \$eventID, userID: \$userID)
  }
  ''';
}

class ConstQuery {

  static const String socialClub = '''
      query socialClub(\$scID: ID!,\$userID: ID!){
       socialClub(scID: \$scID,userID: \$userID){
        scID
        scoID
        title
        description
        imageUrl
        members
        status
    }
  }
  ''';

  static const String socialClubRequests = '''
   query socialClubRequests(\$userID: ID!){
      socialClubRequests(userID: \$userID){
       userID
       name
       surname
       gender
       title
       department
       email
       address
       phone
       imageUrl
       balance
       semester
    }
}
  ''';

  static const String gallery = '''
  query gallery(\$scID: ID!){
      gallery(scID: \$scID){
       postID
       imageUrl
       description
       createdAt
    }
}
  ''';

  static const String socialClubMembers = '''
  query socialClubMembers(\$scID: ID!){
      socialClubMembers(scID: \$scID){
       userID
       name
       surname
       imageUrl
    }
}
  ''';

  static const String mySocialClubs = '''
  query mySocialClubs(\$userID: ID!){
      mySocialClubs(userID: \$userID){
        scID
        scoID
        title
        description
        imageUrl
        members
        status
    }
}
  ''';

  static const String socialClubs = '''
      query socialClubs(){
       socialClubs(){
        scID
        scoID
        title
        description
        imageUrl
        members
        status
    }
  }
  ''';
  static const String meals = '''
  query mealsList(){
          mealsList(){
            meals{
                  mealID
                  mealType
                  mealName
                  mealImageUrl
            }
        }
  }
  ''';
  static const String menu = '''
  query menu(){
          menu(){
               meals{
                  mealID
                  mealType
                  mealName
                  mealImageUrl
            }
        }
  }
  ''';
  static const String listOfAttendees = '''
  query listOfAttendees(\$eventID: ID!){
    listOfAttendees(eventID: \$eventID){
        count
        userID
        eventID
        name
        surname
        phone
        imageUrl
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
  query events(\$userID: ID!,\$typeOfUser: String!){
    events(userID: \$userID, typeOfUser: \$typeOfUser){
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
  static const String postID = "postID";
  static const String action = "action";
  static const String socialClub = "socialClub";
  static const String inputDescription = "inputDescription";
  static const String scoID = "scoID";
  static const String scID = "scID";
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
  static const String title = "title";
  static const String description = "description";
  static const String attendee = "attendee";
  static const String price = "price";
  static const String date = "date";
  static const String time = "time";
  static const String location = "location";
  static const String dayID = "dayID";
  static const String redMeal = "redMeal";
  static const String whiteMeal = "whiteMeal";
  static const String vegMeal = "vegMeal";
  static const String soup = "soup";
  static const String salad = "salad";
  static const String dessert = "dessert";
  static const String menuInput = "menuInput";
  static const String postInput = "postInput";
  static const String image = "image";
}

class ConstAssetsPath {
  static const img_placeHolder = 'assets/images/placeholderImage.png';
  static const img_loginImage = 'assets/images/LoginImage.png';
  static const img_studentCard = 'assets/images/Student Card.jpg';
  static const img_defaultAvatar = 'assets/images/defaultAvatar.jpeg';
  static const img_defaultEvent = 'assets/images/eventPlaceHolder.jpeg';
}

class MyConstants {
  static const List<String> assetProfPaths = [
    'assets/images/Announcements.jpg',
    'assets/images/DinnerHall.jpg',
    'assets/images/Transportation.jpg',
    'assets/images/Events.jpg',
    'assets/images/TimeTable.jpg',
  ];

  static const List<String> routesProf = [
    AnnouncementsScreen.routeName,
    DinnerHallScreen.routeName,
    TransportationScreen.routeName,
    EventScreen.routeName,
    TimeTableScreen.routeName
  ];

  static const List<String> funcProfTitles = [
    "Announcements",
    "Dinner Hall",
    "Transportation",
    "Events",
    "Time Table"
  ];

  static const List<Color> funcColorsProf = [
    Color(0xFFFC7068),
    Color(0xFFFDD530),
    Color(0xFF04D6A7),
    Color(0xFF4DAB57),
    Color(0xFF8562A5),

  ];
  static const List<String> assetStaffPaths = [
    'assets/images/Announcements.jpg',
    'assets/images/DinnerHall.jpg',
    'assets/images/Transportation.jpg',
    'assets/images/Events.jpg',

  ];

  static const List<String> routesStaff = [
    AnnouncementsScreen.routeName,
    DinnerHallScreen.routeName,
    TransportationScreen.routeName,
    EventScreen.routeName,
  ];

  static const List<String> funcStaffTitles = [
    "Announcements",
    "Dinner Hall",
    "Transportation",
    "Events",
  ];

  static const List<Color> funcColorsStaff = [
    Color(0xFFFC7068),
    Color(0xFFFDD530),
    Color(0xFF04D6A7),
    Color(0xFF4DAB57),
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
    AnnouncementsScreen.routeName,
    DocumentRequestScreen.routeName,
    StudentCardScreen.routeName,
    TimeTableScreen.routeName,
    TransportationScreen.routeName,
    EventScreen.routeName,
    SocialClubScreen.routeName,
    DinnerHallScreen.routeName,
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
  static const List<Color> appBarColors = [
    Color(0xFF102255),
    Color(0xFF2B799E),
    Color(0xFF40BDD6),
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
const String str_events = "Events";
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
const String str_editEvent = "Edit Event";
const String str_delete = "Delete";
const String str_warningBeforeEventDelete = "Are you sure you want to delete event?";
const String str_yes = "Yes";
const String str_no = "No";
const String str_details = "Details";
const String str_eventDetails = "Event Details";
const String str_confirm = "Confirm";
const String str_listOfAttendees = "List of Attendees";
const String str_eventAddedSuccess = "Event was successfully added";
const String str_eventRemovedSuccess = "Event successfully removed from your events";
const String str_update = "Update";
const String str_eventName = "Event Name";
const String str_location = "Location";
const String str_isFree = "Is Free";
const String str_enterDescription = "Enter description";
//default values for GraphQL
const str_noImage = "No Image";
const str_false = "false";
const str_defaultImageUrl = "https://res.cloudinary.com/abu-campus-app/image/upload/v1622738747/cikhthfn2p3ireaot99v.png";
const str_defaultImageUrlSC = "https://res.cloudinary.com/abu-campus-app/image/upload/v1622739266/c68zvrhgwzlvgow95x4t.jpg";
//for document request
const String str_studentAffairEmail = "vladyslav.alisov@gmail.com"; //'studentaffairs@antalya.edu.tr';
const String str_requests = "Requests";
const String str_send = "Send";

//for transportation
const String str_routesOfTheServices = "Routes of the services";

//for announcements
const String str_announcements = "Announcements";
const String str_noDataFound = "No data found:(";
const String str_myClubs = "My Clubs";
const String str_allSocialClubs = "All Social Clubs";
const String str_socialClubs = "Social Clubs";
const String str_errorLoadImage = "Could not load an image";
const String str_attendees = "Attendees";
const String str_chooseAnImage = "Choose an image";
const String str_eventUpdatedSuccess = "Event has been successfully updated";
const String str_eventCreatedSuccess = "Event has been successfully created";
const String str_eventDeletedSuccess = "Event successfully deleted";
const String str_eventCanceledSuccess = "Event successfully canceled";
const String str_requestOptions = "Request options";
const String str_sendRequest = "Send request";
const String str_purpose = "Purpose";
const String str_examples = "Examples";
const String str_uploadImageWarn = "Please upload image";
const String str_monday = "Monday";
const String str_tuesday = "Tuesday";
const String str_wednesday = "Wednesday";
const String str_thursday = "Thursday";
const String str_friday = "Friday";
const String str_documentRequest = "Document Request";
const String str_studentCard = "Student Card";
const String str_timeTable = "Timetable";
const String str_transportation = "Transportation";
const String str_dinnerHall = "Dinner Hall";
const String str_menu = "Menu";
const String str_camera = "Camera";
const String str_photoLibrary = "Photo Library";
const String str_authError = "Your username and/or password do not match.";
const String str_connectionError = "Connection problem. Please try again later.";
const String str_somethingWentWrong = "Oups! Something went wrong!";
const String str_dateOfTheEvent = "Date of the event";
const String str_time = "Time";
const String str_select = "Select";

const String str_mySocialClubs = "My Social Clubs";
const String str_manageMySocialClub = "Manage My Social Club";
const String str_socialClubDetails = "Social Club Details";
