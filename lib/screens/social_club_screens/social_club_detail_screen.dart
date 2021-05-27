import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_detail_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryView.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusTitleIconRow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

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
  //todo:  get function to identify is user in the requests and if he/she is already in the club
  bool _isLoading = false;
  bool _isJoined = false;
  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).socialClubRequests().then((_) {
          Provider.of<SocialClubProvider>(context, listen: false)
              .gallery(widget.socialClub.scID)
              .then((_) => setState(() {
                    _isLoading = false;
                  }));
        }),
        context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false).authData;
    final socialClubProvider = Provider.of<SocialClubProvider>(context);
    //_isJoined = eventProvider.myEventList.any((element) => element.title == eventList[args.index].title);

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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.socialClub.imageUrl == null
                                    ? AssetImage(
                                        ConstAssetsPath.img_placeHolder,
                                      )
                                    : NetworkImage(widget.socialClub.imageUrl),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget.socialClub.title.toUpperCase(),
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
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            TitleIconRow(
                              title: "Gallery",
                              titleIcon: Icons.image,
                            ),
                            socialClubProvider.galleryImagesList?.length == 0
                                ? Center(
                                    child: Text("Gallery is empty"),
                                  )
                                : CarouselSlider.builder(
                                    itemCount: socialClubProvider.galleryImagesList?.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return GestureDetector(
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
                                        child: Container(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: socialClubProvider.galleryImagesList[index].imageUrl == null
                                                    ? AssetImage(
                                                        ConstAssetsPath.img_placeHolder,
                                                        //   fit: BoxFit.fill,
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
                                      );
                                    },
                                    options: CarouselOptions(
                                      aspectRatio: 3,
                                      enableInfiniteScroll: false,
                                      enlargeCenterPage: false,
                                      viewportFraction: 0.6,
                                      autoPlay: true,
                                      pauseAutoPlayOnTouch: true,
                                    ),
                                  ),
                            TitleIconRow(
                              title: AppLocalizations.of(context).translate(str_details),
                              titleIcon: Icons.list_alt_outlined,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                widget.socialClub.description,
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 10,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            userData.login.userID == widget.socialClub.scoID
                                ? Container()
                                //     ? Row(
                                //   mainAxisAlignment: MainAxisAlignment.end,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: ElevatedButton(
                                //         style: ButtonStyle(
                                //             backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                                //         onPressed: () {
                                //           Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //               builder: (context) => EventEditScreen(
                                //                 event: eventProvider.eventList[args.index],
                                //               ),
                                //             ),
                                //           );
                                //         },
                                //         child: Text(AppLocalizations.of(context).translate(str_edit)),
                                //       ),
                                //     ),
                                //   ],
                                // )
                                :
                                //todo: check if there are suppose to be some func for owner of the club
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _isLoading
                                          ? CircularProgressIndicator()
                                          : Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: !_isJoined
                                                  ? ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty.all(Theme.of(context).primaryColor),
                                                      ),
                                                      onPressed: () {
                                                        setIsLoading(true);
                                                        CommonController.mutationFuture(
                                                            socialClubProvider
                                                                .sendRequestJoinSocialClub(widget.socialClub.scID),
                                                            "Could not join social club",
                                                            context);
                                                        setIsLoading(false);
                                                      },
                                                      child: Text("Send request"),
                                                    )
                                                  : Container() /*ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Theme.of(context).primaryColor)),
                              onPressed: () {
                                setIsLoading(true);
                                CommonController.mutationFuture(
                                    eventProvider.cancelEvent(eventList[args.index].eventID),
                                    AppLocalizations.of(context).translate(str_eventRemovedSuccess),
                                    context);
                                setIsLoading(false);
                              },
                              child: Text("Waiting"),
                            ),*/
                                              ),
                                    ],
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
  }

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }
}

class CampusIconText extends StatelessWidget {
  const CampusIconText({
    this.icon,
    this.textData,
    this.title,
  });

  final IconData icon;
  final String title;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  icon,
                  size: 15,
                ),
              ),
              Text(""),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      textData,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
