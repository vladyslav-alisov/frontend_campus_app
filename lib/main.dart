import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/home_screen.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/providers.dart';
import 'package:campus_app/utils/routes.dart';
import 'package:campus_app/utils/theme.dart';
import 'package:campus_app/utils/graph_ql_setup.dart';
import 'package:campus_app/widgets/SplashScreen.dart';
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
      providers: ProviderUtil.providers,
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
              routes: RoutesUtil.routes,
            );
          },
        ),
      ),
    );
  }
}
