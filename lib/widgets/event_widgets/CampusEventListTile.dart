import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

class CampusEventListTile extends StatelessWidget {
  CampusEventListTile(this._event, this._popupMenuButton);

  final Event _event;
  final PopupMenuButton _popupMenuButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                child: _event.imageUrl.contains("cloudinary")
                    ? FadeInImage(
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate(str_errorLoadImage),
                              ),
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
            ),
          ),
          Flexible(
            flex: 5,
            child: ListTile(
              title: Text(
                _event.date,
                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _event.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14, color: Color(0xff363636)),
                  ),
                  Text(
                    _event.location,
                    style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14),
                  ),
                  Text(
                    _event.time,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 12,
                        ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: _popupMenuButton,
            ),
          ),
        ],
      ),
    );
  }
}
