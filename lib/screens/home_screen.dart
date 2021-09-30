import 'package:cached_network_image/cached_network_image.dart';
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
      "Notice board",
      AppLocalizations.of(context).translate(str_timeTable),
      AppLocalizations.of(context).translate(str_transportation),
      AppLocalizations.of(context).translate(str_events),
      AppLocalizations.of(context).translate(str_socialClubs),
      AppLocalizations.of(context).translate(str_dinnerHall),
    ];

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
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  authData != null ? authData.login.name + " " + authData.login.surname : "",
                                  style: Theme.of(context).textTheme.headline1,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Flexible(
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: authData.login.imageUrl ?? str_defaultImageUrl,
                                    imageBuilder: (context, imageProvider) => Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  ),
                                ),
                              ),
                            ],
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
