import 'dart:io';

import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SocialClubManageScreenController with ChangeNotifier {
  bool isExpanded = false;
  File galleryImage;
  File socialClubAvatarImage;
  bool isLoading = false;
  bool isImageLoading = false;
  bool isDescriptionLoading = false;
  bool isEdit = false;
CarouselController galleryController;
  TextEditingController descriptionController = TextEditingController();

  void init(String description) {
    galleryController = CarouselController();
    isImageLoading = false;
    isDescriptionLoading = false;
    isEdit = false;
    descriptionController.text = description;
  }

  final picker = ImagePicker();

  void setIsDescriptionLoading() {
    isDescriptionLoading = !isDescriptionLoading;
    notifyListeners();
  }

  void setIsLoading(bool state) {
    isLoading = state;
    notifyListeners();
  }

  void setEdit() {
    isEdit = !isEdit;
    notifyListeners();
  }

  void setIsImageLoading(bool state) {
    isImageLoading = state;
    notifyListeners();
  }

  void showUploadImage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(AppLocalizations.of(context).translate(str_uploadImageWarn)),
      ),
    );
  }

  Future getImage(bool choice,BuildContext context) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
    } else if (!choice) {
      pickedFile = await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) {
        print(e);
      });
    }
    if (pickedFile != null) {
      galleryImage = File(pickedFile.path);
    }
    print(galleryImage);

    notifyListeners();
  }


  void showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(AppLocalizations.of(context).translate(str_photoLibrary)),
                    onTap: () {
                      getImage(false,context);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(AppLocalizations.of(context).translate(str_camera)),
                  onTap: () {
                    getImage(true,context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
