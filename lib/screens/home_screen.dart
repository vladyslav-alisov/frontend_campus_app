import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusCardFunction.dart';
import 'package:campus_app/widgets/CampusClipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum UserType { Student, Cook, Lecturer }

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var lst = [
      AppLocalizations.of(context).translate(str_announcements),
      AppLocalizations.of(context).translate(str_documentRequest),
      AppLocalizations.of(context).translate(str_studentCard),
      AppLocalizations.of(context).translate(str_timeTable),
      AppLocalizations.of(context).translate(str_transportation),
      AppLocalizations.of(context).translate(str_events),
      AppLocalizations.of(context).translate(str_socialClubs),
      AppLocalizations.of(context).translate(str_dinnerHall),
    ];
    print("build");

    var authData = Provider.of<AuthProvider>(context).authData;
    final devSize = MediaQuery.of(context).size;
    return isLoading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : Container(
            color: Colors.white,
            height: devSize.height,
            width: devSize.width,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        width: devSize.width,
                        color: Theme.of(context).primaryColor,
                        height: devSize.height * 0.315,
                      ),
                    ),
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        height: devSize.height * 0.30,
                        width: devSize.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: MyConstants.appBarColors,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 38,
                            right: 17,
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: Text(
                                    authData != null ? authData.login.name + " " + authData.login.surname : "",
                                    style: Theme.of(context).textTheme.headline1,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: authData.login.imageUrl != str_noImage && authData?.login?.imageUrl != null
                                      ? Container(
                                          width: 80,
                                          height: 80,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 25,
                                            child: ClipOval(
                                              child: Image.network(
                                                authData.login.imageUrl,
                                                fit: BoxFit.cover,
                                                width: 80,
                                                height: 80,
                                                errorBuilder: (context, error, stackTrace) {
                                                  print(error);
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey,
                                                    ),
                                                    child: Center(
                                                      child: ClipOval(
                                                        child: Image.asset(ConstAssetsPath.img_defaultAvatar,
                                                            fit: BoxFit.fill),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: CircleAvatar(
                                                child: ClipOval(
                                                  child: Image.asset(ConstAssetsPath.img_defaultAvatar, fit: BoxFit.fill),
                                                ),
                                                radius: devSize == null ? 50 : devSize.width * 0.10,
                                              ),
                                            ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                conditionalView(authData.login.typeOfUser, devSize, lst),
              ],
            ),
          );
  }
}

Widget conditionalView(String type, Size devSize, List list) {
  if (type == describeEnum(UserType.Cook)) {
    return CampusHomeGridView(
      devSize: devSize,
      assets: MyConstants.assetStaffPaths,
      colors: MyConstants.funcColorsStaff,
      routes: MyConstants.routesStaff,
      titles: MyConstants.funcStaffTitles,
    );
  }
  if (type == describeEnum(UserType.Student)) {
    return CampusHomeGridView(
      devSize: devSize,
      assets: MyConstants.assetPaths,
      colors: MyConstants.funcColors,
      routes: MyConstants.routes,
      titles: list,
    );
  }
  if (type == describeEnum(UserType.Lecturer)) {
    return CampusHomeGridView(
      devSize: devSize,
      assets: MyConstants.assetProfPaths,
      colors: MyConstants.funcColorsProf,
      routes: MyConstants.routesProf,
      titles: MyConstants.funcProfTitles,
    );
  } else
    return CampusHomeGridView(
      devSize: devSize,
      assets: MyConstants.assetProfPaths,
      colors: MyConstants.funcColorsProf,
      routes: MyConstants.routesProf,
      titles: MyConstants.funcProfTitles,
    );
}

class CampusHomeGridView extends StatelessWidget {
  CampusHomeGridView({
    @required this.devSize,
    this.assets,
    this.colors,
    this.routes,
    this.titles,
  });

  final Size devSize;
  List<String> titles;
  List<String> assets;
  List<Color> colors;
  List<String> routes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: devSize.height * 0.685,
      width: devSize.width,
      child: GridView.builder(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
          top: 10,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 17.0,
        ),
        itemCount: titles.length,
        itemBuilder: (context, index) => cardFunction(
          context: context,
          imagePath: assets[index],
          label: titles[index],
          color: colors[index],
          path: routes[index],
        ),
      ),
    );
  }
}
