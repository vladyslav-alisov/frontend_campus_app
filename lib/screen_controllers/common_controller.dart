import 'dart:io';

import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommonController {
  static Future<void> queryFuture(Future future, BuildContext context) async {
    await future.catchError((e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            label: AppLocalizations.of(context).translate(str_hideMessage),
            textColor: Colors.white,
          ),
          content: Text(e.toString()),
        ),
      );
    });
  }

  static Future<void> mutationFuture(Future future, String successMsg, BuildContext context) async {
    await future.then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text(successMsg),
        ),
      );
    }).catchError(
      (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(e.toString()),
          ),
        );
      },
    );
  }

  static Future<File> getAndUpdateImage(bool choice) async {
    var picker = ImagePicker();
    var pickedFile;
    if (choice) {
      pickedFile =
      await picker.pickImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
    } else if (!choice) {
      pickedFile =
      await picker.pickImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
    }
    if(pickedFile!=null){
      return File(pickedFile.path);
    }
    else return null;

  }
  static int today() {
    var today = DateTime.now().weekday;
    if (today == 6 || today == 7) {
      today = 1;
    }
    return today;
  }
}
