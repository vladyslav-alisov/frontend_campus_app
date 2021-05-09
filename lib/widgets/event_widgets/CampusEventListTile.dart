import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

class CampusEventListTile extends StatelessWidget {
  CampusEventListTile(this._event, this._popupMenuButton);

  final Event _event;
  final PopupMenuButton _popupMenuButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(_event.title),
        subtitle: Text("${_event.date}  \n ${_event.time}"),
        isThreeLine: true,
        trailing: _popupMenuButton,
        leading: _event.imageUrl.contains("cloudinary")
            ? FadeInImage(
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    child: Center(
                      child: Text("Could not load an image"),
                    ),
                  );
                },
                placeholder: AssetImage(ConstAssetsPath.img_placeHolder),
                image: NetworkImage(_event.imageUrl),
              )
            : Image.asset(
                ConstAssetsPath.img_placeHolder,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
