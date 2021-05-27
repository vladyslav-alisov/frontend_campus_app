import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

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

  static int today() {
    var today = DateTime.now().weekday;
    if (today == 6 || today == 7) {
      today = 1;
    }
    return today;
  }
}
