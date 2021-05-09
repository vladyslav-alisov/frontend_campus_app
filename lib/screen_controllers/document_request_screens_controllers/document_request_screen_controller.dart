import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentRequestScreenController with ChangeNotifier {
  void showPurposeDialog(BuildContext context, Future<void> function(String string)) {
    String purpose;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: new Text("Purpose"),
        content: TextField(
          decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 10),
              hintText: "Examples: Application for erasmus, Immigration Department"),
          onChanged: (value) {
            purpose = value;
            notifyListeners();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate(str_cancel)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(str_send),
            onPressed: () async {
              await function(purpose);
            },
          ),
        ],
      ),
    );
  }
}
//documentRequestProvider.sendTranscriptRequest();
