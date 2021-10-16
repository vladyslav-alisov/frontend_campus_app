import 'package:flutter/material.dart';

class CampusRequestListTile extends StatelessWidget {
  CampusRequestListTile(this._requestTitle,this._requestDescription, this._button);

  final String _requestTitle;
  final String _requestDescription;
  final ElevatedButton _button;
  @override
  Widget build(BuildContext context) {
    return Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(10),
       ),
      child: ListTile(
        dense: true,
        title: Text(_requestTitle),
        subtitle: Text(_requestDescription),
        isThreeLine: true,
        trailing: FittedBox(child: _button),
      ),
    );
  }
}
