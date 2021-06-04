import 'dart:io';
import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/screens/social_club_screens/social_club_add_post_screen.dart';
import 'package:campus_app/screens/social_club_screens/social_club_members.dart';
import 'package:campus_app/screens/social_club_screens/social_club_requests.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryView.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusTitleIconRow.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class SocialClubManageScreen extends StatefulWidget {
  static const String routeName = "/social_club_manage_screen";

  SocialClubManageScreen({this.socialClub});
  final SocialClub socialClub;

  @override
  _SocialClubManageScreenState createState() => _SocialClubManageScreenState();
}

class _SocialClubManageScreenState extends State<SocialClubManageScreen> {
  bool _isLoading = false;
  String temp="";

  @override
  void initState() {
    _isLoading = true;
    Provider.of<SocialClubManageScreenController>(context, listen: false).init(widget.socialClub?.description);
    CommonController.queryFuture(
        Provider.of<SocialClubProvider>(context, listen: false).socialClub(widget.socialClub.scID).then((_) {
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
    print("build");
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
                      screenController.isImageLoading
                          ? AspectRatio(
                              aspectRatio: 1.5,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => CampusAvatarSocialClub()));
                              },
                              child: AspectRatio(
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
                                          colorFilter:
                                              ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.darken),
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
                                  child: CampusTitleIconRow(
                                    title: "Gallery",
                                    trailingIcon: Icons.add_a_photo,
                                    titleIcon: Icons.photo_library,
                                    callback: () => Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (context) => SocialClubManageScreenController(),
                                          child: AddPostScreen(socialClubProvider.socialClubDetail),
                                        );
                                      },
                                    )),
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
                                  padding: const EdgeInsets.only(left: 8),
                                  child: CampusTitleIconRow(
                                    title: AppLocalizations.of(context).translate(str_details),
                                    trailingIcon: Icons.edit,
                                    titleIcon: Icons.list_alt_outlined,
                                    secondTrailingIcon: screenController.isEdit ? Icons.save : null,
                                    secondCallback: () async {
                                      screenController.setEdit();
                                      screenController.setIsDescriptionLoading();
                                      await CommonController.mutationFuture(
                                              socialClubProvider.editDescriptionSocialClub(
                                                  socialClubProvider.socialClubDetail.scoID,
                                                  socialClubProvider.socialClubDetail.scID,
                                                  screenController.descriptionController.text),
                                              "Descriptions updated",
                                              context)
                                          .then((_) => screenController.setIsDescriptionLoading());
                                    },
                                    callback: () {
                                      if (screenController.isDescriptionLoading) {
                                      } else {
                                        screenController.setEdit();
                                        if(screenController.isEdit==true){
                                          print(screenController.isEdit);
                                          temp = screenController.descriptionController.text;
                                          print(temp);
                                        }
                                        else{
                                          if((temp.compareTo(screenController.descriptionController.text) == 0) == false ){
                                            screenController.descriptionController.text=temp;
                                          }
                                        }

                                      }
                                    },
                                  ),
                                ),
                                screenController.isEdit
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: TextField(
                                          controller: screenController.descriptionController,
                                          textAlign: TextAlign.left,
                                          autocorrect: true,
                                          maxLines: 20,
                                          style: Theme.of(context).textTheme.bodyText2,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                              borderSide: BorderSide(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0, right: 20, left: 20),
                                        child: Text(
                                          screenController.descriptionController.text,
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 20,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: CampusTitleIconRow(
                                    title: "Members",
                                    titleIcon: Icons.people,
                                    trailingIcon: Icons.edit,
                                    secondTrailingIcon: Icons.person_add,
                                    callback: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SocialClubMembersScreen(
                                          socialClub: socialClubProvider.socialClubDetail,
                                        ),
                                      ),
                                    ),
                                    secondCallback: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SocialClubRequestsScreen(
                                          socialClub: socialClubProvider.socialClubDetail,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0, right: 20, left: 28),
                                      child: Text(
                                        socialClubProvider.socialClubDetail.members.toString() + " Students",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
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
            ),
    );
  }
}

class CampusAvatarSocialClub extends StatefulWidget {
  @override
  _CampusAvatarSocialClubState createState() => _CampusAvatarSocialClubState();
}

class _CampusAvatarSocialClubState extends State<CampusAvatarSocialClub> {
  var picker = ImagePicker();
  bool isLoading = false;
  File avatarImage;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        body: isLoading
            ? Container(
                color: Colors.black,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
            : Stack(
                fit: StackFit.expand,
                children: [
                  PhotoView.customChild(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage(ConstAssetsPath.img_defaultAvatar),
                      image: NetworkImage(socialClubProvider.socialClubDetail.imageUrl),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.more_vert_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                socialClubProvider.socialClubDetail.imageUrl == str_defaultImageUrlSC
                                    ? Container()
                                    : ListTile(
                                        leading: new Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        title: new Text(
                                          AppLocalizations.of(context).translate(str_delete),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: new Text(
                                                    AppLocalizations.of(context).translate(str_simpleWarning)),
                                                content: new Text(AppLocalizations.of(context)
                                                    .translate(str_warningBeforeEventDelete)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(AppLocalizations.of(context).translate(str_confirm)),
                                                    onPressed: () async {
                                                      if(socialClubProvider.galleryImagesList.length==1){
                                                        Navigator.of(context).popUntil(ModalRoute.withName(SocialClubManageScreen.routeName));
                                                      }
                                                      Navigator.pop(context);
                                                      setIsLoading();
                                                      await socialClubProvider.deleteAvatarSocialClub();
                                                      setIsLoading();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text(AppLocalizations.of(context).translate(str_photoLibrary)),
                                  onTap: () async {
                                    await getAndUpdateImage(false, socialClubProvider);
                                    Navigator.pop(context);
                                    if (avatarImage != null) {
                                      setIsLoading();
                                      await socialClubProvider.uploadAvatarSocialClub(avatarImage);
                                      setIsLoading();
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text(AppLocalizations.of(context).translate(str_camera)),
                                  onTap: () async {
                                    await getAndUpdateImage(true, socialClubProvider);
                                    Navigator.pop(context);
                                    if (avatarImage != null) {
                                      setIsLoading();
                                      await socialClubProvider.uploadAvatarSocialClub(avatarImage);
                                      setIsLoading();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListTile(
                                  leading: new Icon(Icons.cancel),
                                  title: new Text(AppLocalizations.of(context).translate(str_cancel)),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future getAndUpdateImage(bool choice, SocialClubProvider socialClubProvider) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    } else if (!choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
      if (pickedFile == null) {
        return;
      }
    }
    if (pickedFile != null) {
      avatarImage = File(pickedFile.path);
    }
  }
}
