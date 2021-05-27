import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentRequestScreenController with ChangeNotifier {
  void showPurposeDialog(BuildContext context, Future<void> function(String string)) {
    String purpose;
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: new Text(AppLocalizations.of(context).translate(str_purpose)),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              if(value!= null && value.isNotEmpty){
                return null;
              }
              else{
                return AppLocalizations.of(context).translate(str_enterSomeText);
              }
            },
            decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 10),
                hintText: "${AppLocalizations.of(context).translate(str_examples)}: Application for erasmus, Immigration Department"),
            onChanged: (value) {
              purpose = value;
              notifyListeners();
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate(str_cancel)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context).translate(str_send)),
            onPressed: () async {
              if(_formKey.currentState.validate()){
                await function(purpose);
              }
            },
          ),
        ],
      ),
    );
  }
}
//documentRequestProvider.sendTranscriptRequest();
