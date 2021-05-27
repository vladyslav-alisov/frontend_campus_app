import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/general_widgets/CampusPersonListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialClubMembersScreen extends StatefulWidget {
  static const routeName = "/social_club_members";
  SocialClubMembersScreen({this.socialClubID});
  final String socialClubID;
  @override
  _SocialClubMembersScreenState createState() => _SocialClubMembersScreenState();
}

class _SocialClubMembersScreenState extends State<SocialClubMembersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).socialClubMembers(widget.socialClubID), context)
        .then((value) {
      setState(() {
        _isLoading = false; //false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socialClubProvider = Provider.of<SocialClubProvider>(context, listen: false);
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
            child: CampusPersonListTile(
                surname: socialClubProvider.socialClubMembersList[index].surname,
                name: socialClubProvider.socialClubMembersList[index].name,imageUrl: socialClubProvider.socialClubMembersList[index].imageUrl,),
          );
        },
      ),
    );
  }
}


