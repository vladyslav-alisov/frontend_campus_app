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
import 'package:campus_app/screen_controllers/event_screens_controllers/event_edit_screen_controller.dart';
import 'package:campus_app/screens/announcements_screens/announcements_screen.dart';
import 'package:campus_app/screens/document_request_screen.dart';
import 'package:campus_app/screens/event_screens/event_attendees_screen.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/screens/menu_screens/menu_edit_screen.dart';
import 'package:campus_app/screens/menu_screens/menu_screen.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/screens/socialClub_screen.dart';
import 'package:campus_app/screens/timeTable_screen.dart';
import 'package:campus_app/screens/transportation_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/Theme.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/widgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        ChangeNotifierProvider(
          create: (_) => SocialClubProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          update: (context, authData, previousProfData) => UserProvider(
            authData.authData,
            previousProfData == null ? null : previousProfData.user,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, EventsProvider>(
          update: (context, authData, previousEvents) => EventsProvider(
            authData.authData,
            previousEvents == null ? [] : previousEvents.eventList,
            previousEvents == null ? [] : previousEvents.myEventList,
            previousEvents == null ? [] : previousEvents.hostEventList,
            previousEvents == null ? [] : previousEvents.attendeeList,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, MenuProvider>(
          update: (context, authData, previousMenu) => MenuProvider(
            authData.authData,
            previousMenu == null ? null : previousMenu.menus,
            previousMenu == null ? [] : previousMenu.menuList,
          ),
        ),
        ChangeNotifierProxyProvider<UserProvider,DocumentRequestProvider>(
          update: (context,userData,previousData) => DocumentRequestProvider(userData.user),
        ),
        ChangeNotifierProvider(
          create: (_) =>TransportationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) =>AnnouncementsProvider(),
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
                Locale('en', ''),
                Locale('ru', ''),
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
                MenuScreen.routeName: (context) => MenuScreen(),
                DocumentRequestScreen.routeName: (context) => DocumentRequestScreen(),
                AnnouncementsScreen.routeName:(context) => AnnouncementsScreen(),
                TransportationScreen.routeName:(context) => TransportationScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
