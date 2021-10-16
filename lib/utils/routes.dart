import 'package:campus_app/screens/announcements_screens/announcements_screen.dart';
import 'package:campus_app/screens/dinner_hall_screens/dinner_hall.dart';
import 'package:campus_app/screens/dinner_hall_screens/menu_edit_screen.dart';
import 'package:campus_app/screens/document_request_screen.dart';
import 'package:campus_app/screens/event_screens/event_attendees_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/screens/notice_board_screens/notice_board_screen.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_manage_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_members.dart';
import 'package:campus_app/screens/social_club_screens/social_club_requests.dart';
import 'package:campus_app/screens/social_club_screens/social_club_screen.dart';
import 'package:campus_app/screens/time_table_screen.dart';
import 'package:campus_app/screens/transportation_screens/transportation_screen.dart';
import 'package:flutter/material.dart';

class RoutesUtil{
  static final Map<String, WidgetBuilder> routes = {
    HomeScreen.routeName: (context) => HomeScreen(),
    ProfileScreen.routeName: (context) => ProfileScreen(),
    TimeTableScreen.routeName: (context) => TimeTableScreen(),
    SocialClubScreen.routeName: (context) => SocialClubScreen(),
    EventScreen.routeName: (context) => EventScreen(),
    LoginScreen.routeName: (context) => LoginScreen(),
    EventDetailScreen.routeName: (context) => EventDetailScreen(),
    MyEventsScreen.routeName: (context) => MyEventsScreen(),
    EventEditScreen.routeName: (context) => EventEditScreen(),
    EventAttendeesScreen.routeName: (context) => EventAttendeesScreen(),
    MenuEditScreen.routeName: (context) => MenuEditScreen(),
    DinnerHallScreen.routeName: (context) => DinnerHallScreen(),
    DocumentRequestScreen.routeName: (context) => DocumentRequestScreen(),
    AnnouncementsScreen.routeName: (context) => AnnouncementsScreen(),
    TransportationScreen.routeName: (context) => TransportationScreen(),
    NoticeBoardScreen.routeName: (context) => NoticeBoardScreen(),
    SocialClubManageScreen.routeName: (context) => SocialClubManageScreen(),
    SocialClubMembersScreen.routeName: (context) => SocialClubMembersScreen(),
    SocialClubRequestsScreen.routeName: (context) => SocialClubRequestsScreen(),
  };
}