import 'package:campus_app/models/social_clubs/GalleryList.dart';
import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/social_club_add_post_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryList.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryView.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusTitleIconRow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialClubManageScreen extends StatelessWidget {
  static const String routeName = "/social_club_manage_screen";

  SocialClubManageScreen({this.socialClub});
  final SocialClub socialClub;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialClubManageScreenController(),
      child: SocialClubManageScaffold(socialClub),
    );
  }
}

class SocialClubManageScaffold extends StatefulWidget {
  SocialClubManageScaffold(this._socialClub);
  final SocialClub _socialClub;

  @override
  _SocialClubManageScaffoldState createState() => _SocialClubManageScaffoldState();
}

class _SocialClubManageScaffoldState extends State<SocialClubManageScaffold> {
  bool _isLoading = false;
  @override
  void initState() {
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).socialClubMembers(widget._socialClub.scID).then((_) {
          Provider.of<SocialClubProvider>(context, listen: false)
              .gallery(widget._socialClub.scID)
              .then((_) => setState(() {
                    _isLoading = false;
                  }));
        }),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<SocialClubManageScreenController>(context);
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: "Manage Your Club",
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: widget._socialClub.imageUrl == null
                                      ? AssetImage(
                                          ConstAssetsPath.img_placeHolder,
                                        )
                                      : NetworkImage(widget._socialClub.imageUrl),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.darken),
                                  onError: (exception, stackTrace) => Container(
                                    child: Center(
                                      child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  widget._socialClub.title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TitleIconRow(
                                    title: "Gallery",
                                    trailingIcon: Icons.add_a_photo,
                                    titleIcon: Icons.photo_library,
                                    callback: () => Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (context) => SocialClubManageScreenController(),
                                          child: AddPostScreen(widget._socialClub),
                                        );
                                      },
                                    )),
                                  ),
                                ),
                                socialClubProvider.galleryImagesList?.length == 0
                                    ? Center(
                                        child: Text("Gallery is empty"),
                                      )
                                    : CampusGalleryList(galleryList: socialClubProvider.galleryImagesList),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: TitleIconRow(
                                    title: AppLocalizations.of(context).translate(str_details),
                                    trailingIcon: Icons.edit,
                                    titleIcon: Icons.list_alt_outlined,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    widget._socialClub.description,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                /*SingleChildScrollView(
                            child: ExpansionTile(
                              title: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                            Icons.people,
                                            size: 15,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            "Members of the club",
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              children: [
                                ListView.builder(
                                  itemCount: socialClubProvider.socialClubMembersList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: CampusPersonListTile(
                                            surname: socialClubProvider.socialClubMembersList[index].surname,
                                            name: socialClubProvider.socialClubMembersList[index].name),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              */ /*ListView.builder(
                                itemCount: socialClubProvider.socialClubMembersList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      child: AttendeeListTile(
                                          surname: socialClubProvider.socialClubMembersList[index].surname,
                                          name: socialClubProvider.socialClubMembersList[index].name),
                                    ),
                                  );
                                },
                              ),*/ /*
                            ),
                        )*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}


