import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampusCheckBox extends StatefulWidget {
  @override
  _CampusCheckBoxState createState() => _CampusCheckBoxState();
}

class _CampusCheckBoxState extends State<CampusCheckBox> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: value ? Color(0xff40BDD6) : Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(28)),
      child: CheckboxListTile(

        controlAffinity: ListTileControlAffinity.trailing,
        selected: value,
        onChanged: (_) {
          setState(
            () {
              value = !value;
            },
          );
        },
        value: value,
        checkColor: Theme.of(context).primaryColor,
        secondary: IconButton(icon: Icon(Icons.error),
        onPressed: () => print("hello"),),
        activeColor: Color(0xff40BDD6),
        isThreeLine: true,
        title: Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: Text(
            "Olympos Camping & Outdoor Activities",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "From 30/04 to 02/05 Meeting point: 5M Migros at 3 PM on 30/04 Outdoor Club will provide the tents",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
