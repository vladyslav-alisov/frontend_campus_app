import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/my_social_clubs_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_detail_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_manage_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SocialClubOwnerMenu { My_Social_Clubs, Manage_My_Social_Club }

enum SocialClubMenu {
  My_Social_Clubs,
}

class SocialClubScreen extends StatelessWidget {
  static const routeName = '/social_club_screen';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialClubScreenController(),
      child: SocialClubScaffold(),
    );
  }
}

class SocialClubScaffold extends StatefulWidget {
  @override
  _SocialClubScaffoldState createState() => _SocialClubScaffoldState();
}

class _SocialClubScaffoldState extends State<SocialClubScaffold> {
  bool _isLoading = false;

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).socialClubs().then((_) {
          setState(() {
            _isLoading = false;
          });
        }),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authData = Provider.of<AuthProvider>(context).authData.login.socialClub;
    print(authData);
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    var screenController = Provider.of<SocialClubScreenController>(context);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 10,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate(str_socialClubs),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  actions: [
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return authData == str_false
                            ? List.generate(
                                SocialClubMenu.values.length,
                                (popupIndex) {
                                  return PopupMenuItem(
                                    value: SocialClubMenu.values[popupIndex].index,
                                    child: Text(AppLocalizations.of(context).translate(
                                        (describeEnum(SocialClubMenu.values[popupIndex])).replaceAll("_", " "))),
                                  );
                                },
                              )
                            : List.generate(
                                SocialClubOwnerMenu.values.length,
                                (popupIndex) {
                                  return PopupMenuItem(
                                    value: SocialClubOwnerMenu.values[popupIndex].index,
                                    child: Text(AppLocalizations.of(context).translate(
                                        (describeEnum(SocialClubOwnerMenu.values[popupIndex])).replaceAll("_", " "))),
                                  );
                                },
                              );
                      },
                      icon: Icon(Icons.more_vert_sharp),
                      onSelected: (value) {
                        if (value == SocialClubMenu.My_Social_Clubs.index) {
                          Navigator.pushNamed(context, MySocialClubsScreen.routeName);
                        }
                        if (value == SocialClubOwnerMenu.Manage_My_Social_Club.index) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SocialClubManageScreen(socialClub: socialClubProvider.socialClubList
                                    .firstWhere((element) => element.title == authData)),
                              ));
                        }
                      },
                    ),
                  ],
                  centerTitle: false,
                  floating: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyConstants.appBarColors,
                      ),
                    ),
                  ),
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SocialClubDetailScreen(socialClubProvider.socialClubList[index])),
                        )
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: socialClubProvider.socialClubList[index].imageUrl == null
                                      ? AssetImage(
                                          ConstAssetsPath.img_placeHolder,
                                          //   fit: BoxFit.fill,
                                        )
                                      : NetworkImage(socialClubProvider.socialClubList[index].imageUrl),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
                                  onError: (exception, stackTrace) => Container(
                                    child: Center(
                                      child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                socialClubProvider.socialClubList[index].title,
                                style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    childCount: socialClubProvider.socialClubList.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.7),
                )
              ],
            ),
          );
  }
}
