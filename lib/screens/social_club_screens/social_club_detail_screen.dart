import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_detail_screen_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/social_club_manage_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_members.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryView.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusTitleIconRow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

enum Condition { member, non, wait }

class SocialClubDetailScreen extends StatelessWidget {
  SocialClubDetailScreen(this.socialClub);
  final SocialClub socialClub;
  static const String routeName = '/social_club_detail_screen';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialClubDetailScreenController(),
      child: SocialClubDetailScaffold(
        socialClub: socialClub,
      ),
    );
  }
}

class SocialClubDetailScaffold extends StatefulWidget {
  SocialClubDetailScaffold({this.socialClub});
  final SocialClub socialClub;
  static const String routeName = '/social_club_detail_screen';
  @override
  _SocialClubDetailScaffoldState createState() => _SocialClubDetailScaffoldState();
}

class _SocialClubDetailScaffoldState extends State<SocialClubDetailScaffold> {
  bool _isLoading = false;
  bool _isRequestLoading = false;

  @override
  void initState() {
    _isLoading = true;
    var socialClubProvider = Provider.of<SocialClubProvider>(context, listen: false);
    CommonController.queryFuture(
        socialClubProvider
            .gallery(widget.socialClub.scID)
            .then((_) => socialClubProvider.socialClub(widget.socialClub.scID))
            .then((_) => setState(() {
                  _isLoading = false;
                })),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context, listen: false).authData;
    final socialClubProvider = Provider.of<SocialClubProvider>(context);
    var authData = Provider.of<AuthProvider>(context).authData;
    var screenController = Provider.of<SocialClubManageScreenController>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title:
              socialClubProvider.socialClubList.firstWhere((element) => element.scID == widget.socialClub.scID).title,
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                image: socialClubProvider.socialClubDetail.imageUrl == null
                                    ? AssetImage(
                                        ConstAssetsPath.img_placeHolder,
                                      )
                                    : NetworkImage(socialClubProvider.socialClubDetail.imageUrl),
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
                                socialClubProvider.socialClubDetail.title.toUpperCase(),
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
                                padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
                                child: CampusTitleIconRow(
                                  title: "Gallery",
                                  titleIcon: Icons.photo_library,
                                ),
                              ),
                              socialClubProvider.galleryImagesList?.length == 0
                                  ? Center(
                                      child: Text("Gallery is empty"),
                                    )
                                  : CarouselSlider.builder(
                                itemCount: socialClubProvider.galleryImagesList.length,
                                carouselController: screenController.galleryController,
                                options: CarouselOptions(
                                  viewportFraction: 0.6,
                                  aspectRatio: 3,
                                  enableInfiniteScroll: false,
                                ),
                                itemBuilder: (context, index, realIndex) => GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GalleryPhotoViewWrapper(
                                          galleryItems: socialClubProvider.galleryImagesList,
                                          initialIndex: index,
                                        ),
                                      ),
                                    ),
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Hero(
                                      tag: socialClubProvider.galleryImagesList[realIndex].postID,
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: socialClubProvider.galleryImagesList[index].imageUrl == null
                                                ? AssetImage(
                                              ConstAssetsPath.img_placeHolder,
                                            )
                                                : NetworkImage(
                                                socialClubProvider.galleryImagesList[index].imageUrl),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) => Container(
                                              child: Center(
                                                child: Text(
                                                    AppLocalizations.of(context).translate(str_errorLoadImage)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
                                child: CampusTitleIconRow(
                                  title: AppLocalizations.of(context).translate(str_details),
                                  titleIcon: Icons.list_alt_outlined,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0, right: 20, left: 20),
                                child: Text(
                                  socialClubProvider.socialClubDetail.description,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 20,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8,),
                                child: CampusTitleIconRow(
                                  title: "Members",
                                  titleIcon: Icons.people,
                                  trailingIcon: Icons.people,
                                  callback: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SocialClubMembersScreen(
                                    socialClub: socialClubProvider.socialClubDetail,
                                  ),
                                ),
                              ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20, left: 28),
                                    child: Text(
                                      socialClubProvider.socialClubDetail.members.toString() + " Students",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ],
                              ),
                              userData.login.userID == socialClubProvider.socialClubDetail.scoID
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                                            ),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SocialClubManageScreen(
                                                    socialClub: socialClubProvider.socialClubList.firstWhere(
                                                        (element) => element.title == authData.login.socialClub)),
                                              ),
                                            ),
                                            child: Text("Edit"),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: identifyCondition(
                                              socialClubProvider.socialClubDetail.status, socialClubProvider, context),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget identifyCondition(String condition, SocialClubProvider socialClubProvider, BuildContext context) {
    if (condition == describeEnum(Condition.non)) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        onPressed: () {
          setIsRequestLoading(true);
          CommonController.mutationFuture(
              socialClubProvider.sendRequestJoinSocialClub(socialClubProvider.socialClubDetail.scID),
              "Request successfully sent",
              context);
          setIsRequestLoading(false);
        },
        child: Text("Send request"),
      );
    } else if (condition == describeEnum(Condition.member)) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
              content: new Text("Are you sure you want to quit Social Club"),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context).translate(str_yes)),
                  onPressed: () async {
                    await CommonController.mutationFuture(
                        socialClubProvider.quitSocialClub(socialClubProvider.socialClubDetail.scID).then((_) {
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
          setIsRequestLoading(false);
        },
        child: Text("Quit"),
      );
    } else if (condition == describeEnum(Condition.wait)) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
        ),
        onPressed: () {
          setIsRequestLoading(true);
          CommonController.mutationFuture(
              socialClubProvider.cancelRequestJoinSocialClub(socialClubProvider.socialClubDetail.scID),
              "Request successfully canceled",
              context);
          setIsRequestLoading(false);
        },
        child: Text("Cancel request"),
      );
    } else
      return Container();
  }

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  void setIsRequestLoading(bool state) {
    setState(() {
      _isRequestLoading = state;
    });
  }
}
