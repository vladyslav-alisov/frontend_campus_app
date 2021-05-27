import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum SocialClubMenu{
  All_Social_Clubs,
  My_Social_Clubs,
  Manage_My_Social_Club
}

class SocialClubScreenController with ChangeNotifier{

  bool isExpanded = false;

  void changeExpanded(){
    isExpanded = !isExpanded;
    notifyListeners();
  }

}