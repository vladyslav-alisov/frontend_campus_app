import 'package:campus_app/providers/announcements_provider.dart';
import 'package:campus_app/providers/document_request_provider.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/home_provider.dart';
import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/providers/notice_board_provider.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/timetable_provider.dart';
import 'package:campus_app/providers/transportation_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/dinner_hall_screen_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderUtil {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeProvider(),
    ),
    ChangeNotifierProxyProvider<AuthProvider, TimeTableProvider>(
      update: (context, authData, previousCourses) =>
          TimeTableProvider(
            authData.authData,
            previousCourses == null ? null : previousCourses.timeTable,
            previousCourses == null ? [] : previousCourses.mondayCourses,
            previousCourses == null ? [] : previousCourses.tuesdayCourses,
            previousCourses == null ? [] : previousCourses.wednesdayCourses,
            previousCourses == null ? [] : previousCourses.thursdayCourses,
            previousCourses == null ? [] : previousCourses.fridayCourses,
          ),
    ),
    ChangeNotifierProxyProvider<AuthProvider, SocialClubProvider>(
      update: (context, authData, previousSocialClubsData) =>
          SocialClubProvider(
            authData.authData,
            previousSocialClubsData == null ? [] : previousSocialClubsData.socialClubList,
            previousSocialClubsData == null ? [] : previousSocialClubsData.mySocialClubList,
            previousSocialClubsData == null ? [] : previousSocialClubsData.socialClubMembersList,
            previousSocialClubsData == null ? [] : previousSocialClubsData.galleryImagesList,
            previousSocialClubsData == null ? [] : previousSocialClubsData.socialClubRequestsList,
            previousSocialClubsData == null ? null : previousSocialClubsData.socialClubDetail,
          ),
    ),
    ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
      update: (context, authData, previousProfData) =>
          ProfileProvider(
            authData,
            previousProfData == null ? null : previousProfData.user,
          ),
    ),
    ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
      update: (context, authData, previousEventsData) =>
          EventsProvider(
            authData.authData,
            previousEventsData == null ? [] : previousEventsData.eventList,
            previousEventsData == null ? [] : previousEventsData.myEventList,
            previousEventsData == null ? [] : previousEventsData.hostEventList,
            previousEventsData == null ? [] : previousEventsData.attendeeList,
          ),
    ),
    ChangeNotifierProxyProvider<AuthProvider, MenuProvider>(
      update: (context, authData, previousMenu) =>
          MenuProvider(
            authData.authData,
            previousMenu == null ? [] : previousMenu.menuList,
            previousMenu == null ? [] : previousMenu.mealOptions,
          ),
    ),
    ChangeNotifierProxyProvider<AuthProvider, NoticeBoardProvider>(
      update: (context, authData, previousNoticeBoard) =>
          NoticeBoardProvider(
            authData.authData,
            previousNoticeBoard == null ? [] : previousNoticeBoard.noticeBoardList,
            previousNoticeBoard == null ? [] : previousNoticeBoard.myNoticeBoardList,
          ),
    ),
    ChangeNotifierProxyProvider<ProfileProvider, DocumentRequestProvider>(
      update: (context, userData, previousData) => DocumentRequestProvider(userData.user),
    ),
    ChangeNotifierProvider(
      create: (_) => TransportationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AnnouncementsProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => MenuEditScreenController(),
    ),
    ChangeNotifierProvider(
      create: (_) => SocialClubManageScreenController(),
    ),
  ];
}