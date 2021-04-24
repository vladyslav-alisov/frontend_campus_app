import 'package:campus_app/models/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  static const String routeName = '/event_detail_screen';
  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventsProvider>(context);
    final eventList = Provider.of<EventsProvider>(context, listen: false).eventList;
    final EventScreen args = ModalRoute.of(context).settings.arguments as EventScreen;
    print(eventList[args.index].eventID);
    _isJoined = eventProvider.myEventList.any((element) => element.title == eventList[args.index].title);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CapmusAppBar(
          title: MyConstants.funcTitles[5],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              color: Color(0xffEFEFEF),
              child: Column(
                children: [
                  Image.asset(
                    ConstAssetsPath.img_loginImage,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                eventList[args.index].title.toUpperCase(),
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_sharp,
                                        size: Theme.of(context).textTheme.bodyText2.fontSize,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(eventList[args.index].location,
                                          style: Theme.of(context).textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_sharp,
                                        size: Theme.of(context).textTheme.bodyText2.fontSize,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(eventList[args.index].date, style: Theme.of(context).textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.access_time_sharp,
                                        size: Theme.of(context).textTheme.bodyText2.fontSize,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(eventList[args.index].time, style: Theme.of(context).textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.ticketAlt,
                                          size: Theme.of(context).textTheme.bodyText2.fontSize),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(eventList[args.index].price, style: Theme.of(context).textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.flag, size: Theme.of(context).textTheme.bodyText2.fontSize),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Event by ${eventList[args.index].organizer}",
                                          style: Theme.of(context).textTheme.bodyText2),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Details"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            eventList[args.index].description,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isLoading
                                ? CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: !_isJoined
                                        ? ElevatedButton(
                                      onPressed: () {
                                        setIsLoading(true);
                                        future(eventProvider.joinEvent(eventList[args.index].eventID), "Event was successfully added",context);
                                      },
                                      child: Text("Join"),
                                    )
                                        : ElevatedButton(
                                      onPressed: () {
                                        setIsLoading(true);
                                        future(eventProvider.cancelEvent(eventList[args.index].eventID), "Event successfully removed from your events", context);
                                      },
                                      child: Text("Cancel"),
                                    )
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> future(Future future, String successMsg, BuildContext context) {
    future.then((_) {
      setIsLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            label: AppLocalizations.of(context).translate(str_hideMessage),
            textColor: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          content: Text(successMsg),
        ),
      );
    }).catchError(
      (e) {
        setIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            action: SnackBarAction(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              label: AppLocalizations.of(context).translate(str_hideMessage),
              textColor: Colors.white,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
            content: Text(e.toString()),
          ),
        );
      },
    );
  }
}
