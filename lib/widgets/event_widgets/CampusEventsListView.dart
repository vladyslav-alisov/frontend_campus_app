import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventsListView extends StatelessWidget {
  const EventsListView({this.event, this.callback});

  final Function callback;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          callback();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: event.imageUrl.contains("cloudinary")
                          ? Card(
                              child: FadeInImage(
                                fit: BoxFit.fill,
                                imageErrorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    child: Center(
                                      child: Text("Could not load an image"),
                                    ),
                                  );
                                },
                                placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                                image: NetworkImage(event.imageUrl),
                              ),
                            )
                          : Image.asset(
                              ConstAssetsPath.img_placeholderImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        event?.title ?? "",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.calendar_today_sharp,
                                            size: 12,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            event?.date ?? "",
                                            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                          ),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Icon(
                                            Icons.location_on_sharp,
                                            size: 12,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Expanded(
                                            child: Text(
                                              event?.location ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.access_time_sharp,
                                            size: 12,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            event?.time ?? "",
                                            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Icon(
                                            FontAwesomeIcons.flag,
                                            size: 12,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            event?.organizer ?? "",
                                            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, top: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).translate(str_price),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  event?.price ?? "",
                                  style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
