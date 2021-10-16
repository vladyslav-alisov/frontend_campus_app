import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/material.dart';

class CampusAppBar extends StatelessWidget {
  final String title;
  final Widget actionWidget;

  CampusAppBar({@required this.title,this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          color: Theme.of(context).primaryColor,
          height: 10,
        ),
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: MyConstants.appBarColors,
          ),
        ),
      ),
      actions: [
        actionWidget!= null ? actionWidget : Container()
      ],
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
