import 'package:flutter/cupertino.dart';

class SocialClub {
  String name;
  String description;
  bool isExpanded;

  SocialClub({
    @required this.name,
    @required this.description,
    this.isExpanded = false,
  });
}
