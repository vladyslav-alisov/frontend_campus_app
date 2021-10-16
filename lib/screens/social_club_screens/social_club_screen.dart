import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/social_club_detail_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_manage_screen.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
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
          Provider.of<SocialClubProvider>(context, listen: false).mySocialClubs().then((_) => setState(() {
                _isLoading = false;
              }));
        }),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authData = Provider.of<AuthProvider>(context).authData;
    var socialClubProvider = Provider.of<SocialClubProvider>(context);

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          labelStyle: Theme.of(context).textTheme.headline1,
                          isScrollable: false,
                          labelPadding: EdgeInsets.all(15),
                          automaticIndicatorColorAdjustment: false,
                          indicatorColor: Colors.grey,
                          tabs: [
                            Text(
                              "Social Clubs",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            Text(
                              "My Social Clubs",
                              style: TextStyle(fontSize: 15, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: MyConstants.appBarColors,
                    ),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context).translate(str_socialClubs),
                  style: Theme.of(context).textTheme.headline1,
                ),
                actions: [
                  authData.login.socialClub == str_false
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SocialClubManageScreen(
                                  socialClub: socialClubProvider.socialClubList
                                      .firstWhere((element) => element.title == authData.login.socialClub)),
                            ),
                          ),
                        ),
                ],
                centerTitle: false,
                floating: true,
              )
            ];
          },
          body: TabBarView(
            children: [
              CampusSocialClubGridView(socialClubList: socialClubProvider.socialClubList),
              socialClubProvider.mySocialClubList.length == 0
                  ? Center(
                      child: Text("Could not find social clubs"),
                    )
                  : CampusSocialClubGridView(socialClubList: socialClubProvider.mySocialClubList),
            ],
          ),
        ),
      ),
    );
  }
}

class CampusSocialClubGridView extends StatelessWidget {
  const CampusSocialClubGridView({
    Key key,
    @required this.socialClubList,
  }) : super(key: key);

  final List<SocialClub> socialClubList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: socialClubList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.7),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SocialClubDetailScreen(
                socialClubList[index],
              ),
            ),
          ),
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: GridTile(
              footer: GridTileBar(
                title: Text(
                  socialClubList[index].title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 15),
                ),
                backgroundColor: Colors.black54,
              ),
              child:
              CachedNetworkImage(
                imageUrl: socialClubList[index].imageUrl,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                progressIndicatorBuilder: (context, url, progress) => Center(child: CircularProgressIndicator(),),
                errorWidget: (context, url, error) {
                  return Container(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(str_errorLoadImage),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
