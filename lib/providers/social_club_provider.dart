import 'package:flutter/material.dart';
import 'package:campus_app/models/socialClub.dart';

class SocialClubProvider with ChangeNotifier{
  bool isExpanded=false;

  void expand(int index, bool isExpanded){
    socialClubsList[index].isExpanded = !socialClubsList[index].isExpanded;
    notifyListeners();
  }

  List<SocialClub> socialClubsList = [
    SocialClub(name: "Music Society", description: "A society for meeting and performing with other musicians or music fans."),
    SocialClub(name: "Chess Club", description: "To spread a chess culture for serious and casual players around the university with weekly socials. We also run an annual inter-university unrated event and link players to externally run tournaments"),
    SocialClub(name: "Theatre Society", description: "Theatre Society is a student-run society, regularly performing 5 shows a year. No matter your passion, it provides the perfect community environment for you to express yourself, have fun, learn theatre skills and forge lifelong friendships!"),
  ];
}