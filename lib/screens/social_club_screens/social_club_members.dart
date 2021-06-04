import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/general_widgets/CampusPersonListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialClubMembersScreen extends StatefulWidget {
  static const routeName = "/social_club_members";
  SocialClubMembersScreen({this.socialClub});
  final SocialClub socialClub;
  @override
  _SocialClubMembersScreenState createState() => _SocialClubMembersScreenState();
}

class _SocialClubMembersScreenState extends State<SocialClubMembersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
            Provider.of<SocialClubProvider>(context, listen: false).socialClubMembers(widget.socialClub.scID), context)
        .then((value) {
      setState(() {
        _isLoading = false; //false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context, listen: false).authData;
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                AppBar().preferredSize.height + 20,
              ),
              child: CampusAppBar(
                title: "Social Club Members",
              ),
            ),
            body: ListView.builder(
              itemCount: socialClubProvider.socialClubMembersList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: userData.login.socialClub == widget.socialClub.title
                      ? CampusPersonListTile(
                          surname: socialClubProvider.socialClubMembersList[index].surname,
                          name: socialClubProvider.socialClubMembersList[index].name,
                          imageUrl: socialClubProvider.socialClubMembersList[index].imageUrl,
                          trailingIcon: userData.login.userID == socialClubProvider.socialClubMembersList[index].userID
                              ? null
                              : Icon(
                                  Icons.remove_circle,
                                  color: Color(0xffC42F2F),
                                ),
                          callback: () async {
                            return showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                content: new Text(
                                    "Are you sure you want to remove ${socialClubProvider.socialClubMembersList[index].name} ${socialClubProvider.socialClubMembersList[index].surname} from club?"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context).translate(str_yes)),
                                    onPressed: () async {
                                      await socialClubProvider
                                          .deleteSCMember(widget.socialClub.scoID, widget.socialClub.scID,
                                              socialClubProvider.socialClubMembersList[index].userID)
                                          .then(
                                        (_) {
                                          Navigator.pop(context);
                                        },
                                      );
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
                          },
                        )
                      : CampusPersonListTile(
                          surname: socialClubProvider.socialClubMembersList[index].surname,
                          name: socialClubProvider.socialClubMembersList[index].name,
                          imageUrl: socialClubProvider.socialClubMembersList[index].imageUrl,
                        ),
                );
              },
            ),
          );
  }
}
