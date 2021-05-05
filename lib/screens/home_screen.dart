import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/profile_screen.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusCardFunction.dart';
import 'package:campus_app/widgets/CampusClipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum UserType { Student , Cook}

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<AuthProvider>(context, listen: false).authData;
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
                                    userData != null ? userData.login.name + " " + userData.login.surname : "",
                                    style: Theme.of(context).textTheme.headline1,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: userData.login.imageUrl != str_noImage
                                      //todo make circular avatar and reduce code size
                                      ? Container(
                                          width: 88,
                                          height: 88,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              onError: (exception, stackTrace) {
                                                print(exception);
                                              },
                                              image: NetworkImage(userData.login.imageUrl),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 88,
                                          height: 88,
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
                userData.login.typeOfUser == describeEnum(UserType.Cook)
                    ? Container(
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
                          itemCount: MyConstants.funcStuffTitles.length,
                          itemBuilder: (context, index) => cardFunction(
                            context: context,
                            imagePath: MyConstants.assetStuffPaths[index],
                            label: MyConstants.funcStuffTitles[index],
                            color: MyConstants.funcColorsStuff[index],
                            path: MyConstants.routesStuff[index],
                          ),
                        ),
                      )
                    : Container(
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
                          itemCount: MyConstants.funcTitles.length,
                          itemBuilder: (context, index) => cardFunction(
                            context: context,
                            imagePath: MyConstants.assetPaths[index],
                            label: MyConstants.funcTitles[index],
                            color: MyConstants.funcColors[index],
                            path: MyConstants.routes[index],
                          ),
                        ),
                      )
              ],
            ),
          );
  }
}
