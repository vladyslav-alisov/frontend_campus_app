import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/home_provider.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/timetable_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/event_screens/create_event_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/screens/socialClub_screen.dart';
import 'package:campus_app/screens/timeTable_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/Theme.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

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
          ),
        ),
      ],
      child: GraphQLProvider(
        client: client,
        child: MaterialApp(
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
          initialRoute: LoginScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            TimeTable.routeName: (context) => TimeTable(),
            SocialClubScreen.routeName: (context) => SocialClubScreen(),
            EventScreen.routeName: (context) => EventScreen(),
            LoginScreen.routeName: (context) => LoginScreen(),
            EventDetailScreen.routeName: (context) => EventDetailScreen(),
            MyEventsScreen.routeName: (context) => MyEventsScreen(),
            CreateEventScreen.routeName: (context) => CreateEventScreen(),
          },
        ),
      ),
    );
  }
}
