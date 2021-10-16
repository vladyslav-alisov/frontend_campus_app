import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialClubRequestsScreen extends StatefulWidget {
  static const routeName = "/social_club_requests";
  SocialClubRequestsScreen({this.socialClub});
  final SocialClub socialClub;
  @override
  _SocialClubRequestsScreenState createState() => _SocialClubRequestsScreenState();
}

class _SocialClubRequestsScreenState extends State<SocialClubRequestsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<SocialClubProvider>(context, listen: false).socialClubRequests(), context)
        .then((value) {
      if(this.mounted){setState(() {
        _isLoading = false; //false;
      });}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            body: socialClubProvider.socialClubRequestsList.length == 0
                ? Center(child: Text("No requests were found"))
                : ListView.builder(
                    itemCount: socialClubProvider.socialClubRequestsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              title: Text(
                                "${socialClubProvider.socialClubRequestsList[index].name} ${socialClubProvider.socialClubRequestsList[index].surname}",
                              ),
                              leading: socialClubProvider.socialClubRequestsList[index].imageUrl != str_noImage &&
                                      socialClubProvider.socialClubRequestsList[index].imageUrl != null
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      child: ClipOval(
                                        child: Image.network(
                                          socialClubProvider.socialClubRequestsList[index].imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${socialClubProvider.socialClubRequestsList[index].name[0].toUpperCase()}${socialClubProvider.socialClubRequestsList[index].surname[0].toUpperCase()}",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${socialClubProvider.socialClubRequestsList[index].name[0].toUpperCase()}${socialClubProvider.socialClubRequestsList[index].surname[0].toUpperCase()}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        socialClubProvider.acceptJoinSocialClubMember(
                                            widget.socialClub.scoID,
                                            widget.socialClub.scID,
                                            socialClubProvider.socialClubRequestsList[index].userID);
                                      },
                                      child: Text("Accept"),
                                      style: ButtonStyle(
                                          visualDensity: VisualDensity.compact,
                                          backgroundColor: MaterialStateProperty.all(Color(0xFF64CDE2))),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        socialClubProvider.denyJoinSocialClub(
                                            widget.socialClub.scoID,
                                            widget.socialClub.scID,
                                            socialClubProvider.socialClubRequestsList[index].userID);
                                      },
                                      child: Text("Ignore"),
                                      style: ButtonStyle(
                                          visualDensity: VisualDensity.compact,
                                          backgroundColor: MaterialStateProperty.all(Color(0XFFA9AEAF))),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              endIndent: 20,
                              indent: 70,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          );
  }
}
