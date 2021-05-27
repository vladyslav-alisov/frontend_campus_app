import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/my_social_clubs_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/social_club_members.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PopUpMenuOptions { Members, Quit_the_club }

class MySocialClubsScreen extends StatelessWidget {
  static const String routeName = '/my_social_clubs_screen';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MySocialClubsScreenController(),
      child: CampusMySocialClubsScaffold(),
    );
  }
}

class CampusMySocialClubsScaffold extends StatefulWidget {
  @override
  _CampusMySocialClubsScaffoldState createState() => _CampusMySocialClubsScaffoldState();
}

class _CampusMySocialClubsScaffoldState extends State<CampusMySocialClubsScaffold> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).mySocialClubs().then((_) {
          setState(() {
            _isLoading = false;
          });
        }),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_mySocialClubs),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : socialClubProvider.mySocialClubList.isEmpty
              ? Center(
                  child: Text(
                    "No social clubs found :(",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemCount: socialClubProvider.mySocialClubList.length ?? 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 4,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: socialClubProvider.mySocialClubList[index]?.imageUrl == null
                                                ? AssetImage(
                                                    ConstAssetsPath.img_placeHolder,
                                                  )
                                                : NetworkImage(socialClubProvider.mySocialClubList[index].imageUrl),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) => Container(
                                              child: Center(
                                                child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  socialClubProvider.mySocialClubList[index].title.toUpperCase(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(fontSize: 12, color: Colors.black),
                                                ),
                                                Text(
                                                  socialClubProvider.mySocialClubList[index].description,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              socialClubProvider.mySocialClubList[index].members.toString() +
                                                  " Members",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton(
                                        icon: Icon(Icons.more_vert_sharp),
                                        onSelected: (value) {
                                          if (value == PopUpMenuOptions.Members.index) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SocialClubMembersScreen(
                                                    socialClubID: socialClubProvider.mySocialClubList[index].scID,
                                                  ),
                                                ));
                                          }
                                          if (value == PopUpMenuOptions.Quit_the_club.index) {
                                            showDialog(
                                              context: context,
                                              builder: (_) => new AlertDialog(
                                                title:
                                                    new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                                content: new Text("Are you sure you want to quit Social Club"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_yes)),
                                                    onPressed: () async {
                                                      await CommonController.mutationFuture(
                                                          socialClubProvider
                                                              .quitSocialClub(
                                                                  socialClubProvider.mySocialClubList[index].scID)
                                                              .then((_) {
                                                            Navigator.pop(context);
                                                          }),
                                                          "You successfully quited social club",
                                                          context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) {
                                          return List.generate(
                                            PopUpMenuOptions.values.length,
                                            (index) {
                                              return PopupMenuItem(
                                                value: PopUpMenuOptions.values[index].index,
                                                child: Text(
                                                    describeEnum(PopUpMenuOptions.values[index]).replaceAll("_", " ")),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
