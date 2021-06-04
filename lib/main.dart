import 'package:campus_app/providers/announcements_provider.dart';
import 'package:campus_app/providers/document_request_provider.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/home_provider.dart';
import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/timetable_provider.dart';
import 'package:campus_app/providers/transportation_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/dinner_hall_screen_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/screens/announcements_screens/announcements_screen.dart';
import 'package:campus_app/screens/document_request_screen.dart';
import 'package:campus_app/screens/event_screens/event_attendees_screen.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_manage_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_members.dart';
import 'package:campus_app/screens/social_club_screens/social_club_requests.dart';
import 'package:campus_app/screens/social_club_screens/social_club_screen.dart';
import 'package:campus_app/screens/student_card_screen.dart';
import 'package:campus_app/screens/time_table_screen.dart';
import 'package:campus_app/screens/transportation_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/Theme.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/widgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/dinner_hall_screens/dinner_hall.dart';
import 'screens/dinner_hall_screens/menu_edit_screen.dart';

void main() async {
  await initHiveForFlutter();
  GraphQLSetup setup = GraphQLSetup();
  runApp(MyApp(
    client: setup.client,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({@required this.client});
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TimeTableProvider>(
          update: (context, authData, previousCourses) => TimeTableProvider(
            authData.authData,
            previousCourses == null ? null : previousCourses.timeTable,
            previousCourses == null ? [] : previousCourses.mondayCourses,
            previousCourses == null ? [] : previousCourses.tuesdayCourses,
            previousCourses == null ? [] : previousCourses.wednesdayCourses,
            previousCourses == null ? [] : previousCourses.thursdayCourses,
            previousCourses == null ? [] : previousCourses.fridayCourses,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider,SocialClubProvider>(
          update: (context, authData, previousSocialClubsData) => SocialClubProvider(
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
          update: (context, authData, previousProfData) => ProfileProvider(
            authData,
            previousProfData == null ? null : previousProfData.user,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
          update: (context, authData, previousEventsData) => EventsProvider(
            authData.authData,
            previousEventsData == null ? [] : previousEventsData.eventList,
            previousEventsData == null ? [] : previousEventsData.myEventList,
            previousEventsData == null ? [] : previousEventsData.hostEventList,
            previousEventsData == null ? [] : previousEventsData.attendeeList,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MenuProvider>(
          update: (context, authData, previousMenu) => MenuProvider(
            authData.authData,
            previousMenu == null ? [] : previousMenu.menuList,
            previousMenu == null ? [] : previousMenu.mealOptions,
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
      ],
      child: GraphQLProvider(
        client: client,
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return MaterialApp(
              builder: (context, child) {
                return MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child);
              },
              supportedLocales: [
                Locale('en', ''),//todo: add when configure is ready
               /* Locale('ru', ''),
                Locale('tr', ''),*/
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              title: "Campus App",
              theme: appTheme,
              home: auth.isAuth
                  ? HomeScreen()
                  : FutureBuilder(
                      future: auth.checkUsersData(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting ? SplashScreen() : LoginScreen()),
              routes: {
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
                StudentCardScreen.routeName: (context) => StudentCardScreen(),
                SocialClubManageScreen.routeName: (context) => SocialClubManageScreen(),
                SocialClubMembersScreen.routeName: (context) => SocialClubMembersScreen(),
                SocialClubRequestsScreen.routeName: (context) => SocialClubRequestsScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
