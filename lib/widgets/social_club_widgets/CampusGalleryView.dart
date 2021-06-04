import 'dart:io';

import 'package:campus_app/models/social_clubs/GalleryList.dart';
import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/screen_controllers/social_club_screen_controllers/social_club_manage_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.initialIndex = 0,
    this.galleryItems,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<Gallery> galleryItems;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex = 0;
  var picker = ImagePicker();
  bool isLoading = false;
  File avatarImage;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    photoController = PhotoViewController();
    super.initState();
  }

  PhotoViewController photoController;

  @override
  Widget build(BuildContext context) {
    var socialClubProvider = Provider.of<SocialClubProvider>(context);
    var screenController = Provider.of<SocialClubManageScreenController>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),
      onDismissed: (_) {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              // color: Colors.black,
              ),
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              isLoading
                  ? Container(
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : widget.galleryItems.length == 0
                      ? Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Gallery is empty",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : PhotoViewGallery.builder(
                          scrollPhysics: const BouncingScrollPhysics(),
                          builder: (context, index) => PhotoViewGalleryPageOptions(
                            heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryItems[index].postID),
                            imageProvider: NetworkImage(widget.galleryItems[index].imageUrl),
                            controller: photoController,
                          ),
                          itemCount: widget.galleryItems.length,
                          pageController: widget.pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                            screenController.galleryController.jumpToPage(index);
                          },
                          scrollDirection: Axis.horizontal,
                        ),
              widget.galleryItems.length == 0
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          widget.galleryItems[currentIndex].description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            decoration: null,
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.topRight,
                child: socialClubProvider.authData.login.socialClub != socialClubProvider.socialClubDetail.title
                    ? Container()
                    : Padding(
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
                                  ListTile(
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
                                      print(currentIndex);
                                      if (!(widget.galleryItems.length == 0)) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                              content: new Text(
                                                  AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
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
                                                    Navigator.pop(context);
                                                    setIsLoading();
                                                    await socialClubProvider.deletePost(
                                                        socialClubProvider.galleryImagesList[currentIndex].postID);
                                                    if(currentIndex!=0){
                                                      currentIndex--;
                                                    }
                                                    setIsLoading();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                alignment: Alignment.topLeft,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getAndUpdateImage(bool choice) async {
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
