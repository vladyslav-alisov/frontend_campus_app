import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusMyEventsView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEventsScreen extends StatefulWidget {
  static const String routeName = "/my_events_screen";
  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  bool _isLoading = false;

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    if (authData.socialClub != str_false) {
      CommonController.queryFuture(Provider.of<EventsProvider>(context, listen: false).hostEvents(), context);
    }
    CommonController.queryFuture(Provider.of<EventsProvider>(context, listen: false).myEvents(), context).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventsProvider>(context);
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    if (!_isLoading) {
      return authData.socialClub == str_false
          ? Scaffold(
              appBar: AppBar(
                centerTitle: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: MyConstants.appBarColors,
                    ),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context).translate(str_myEvents),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              body: ListView.builder(
                  itemCount: eventProvider.myEventList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return CampusMyEventCard(
                      index: index,
                      eventList: eventProvider.myEventList,
                      functionButtonOne: () {},
                      functionButtonTwo: () {
                        showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                            title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                            content: new Text(AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context).translate(str_yes)),
                                onPressed: () async {
                                  await CommonController.mutationFuture(
                                      eventProvider.cancelEvent(eventProvider.myEventList[index].eventID).then((_) {
                                        Navigator.pop(context);
                                      }),
                                      "Event successfully canceled",
                                      context);
                                },
                              ),
                              TextButton(
                                child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      iconButtonOne: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      iconButtonTwo: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                      ),
                      titleButtonOne: str_seeAttendees,
                      titleButtonTwo: str_cancel,
                    );
                  }),
            )
          : DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  bottom: TabBar(
                    labelStyle: Theme.of(context).textTheme.headline1,
                    isScrollable: false,
                    labelPadding: EdgeInsets.all(5),
                    automaticIndicatorColorAdjustment: true,
                    tabs: [
                      Text(
                        AppLocalizations.of(context).translate(str_myEvents),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        AppLocalizations.of(context).translate(str_hosting),
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: MyConstants.appBarColors,
                      ),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate(str_myEvents),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                body: TabBarView(
                  children: [
                    ListView.builder(
                        itemCount: eventProvider.myEventList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return CampusMyEventCard(
                            index: index,
                            eventList: eventProvider.myEventList,
                            functionButtonOne: () {},
                            functionButtonTwo: () {
                              showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                  content:
                                      new Text(AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_yes)),
                                      onPressed: () async {
                                        await CommonController.mutationFuture(
                                            eventProvider
                                                .cancelEvent(eventProvider.myEventList[index].eventID)
                                                .then((_) {
                                              Navigator.pop(context);
                                            }),
                                            "Event successfully canceled",
                                            context);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            iconButtonOne: Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            iconButtonTwo: Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                            titleButtonOne: str_seeAttendees,
                            titleButtonTwo: str_cancel,
                          );
                        }),
                    ListView.builder(
                      itemCount: eventProvider.hostEventList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return CampusMyEventCard(
                          index: index,
                          eventList: eventProvider.hostEventList,
                          functionButtonOne: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventEditScreen(
                                  event: eventProvider.hostEventList[index],
                                ),
                              ),
                            );
                          },
                          functionButtonTwo: () {
                            showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                content: new Text(AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      AppLocalizations.of(context).translate(str_yes),
                                    ),
                                    onPressed: () async {
                                      await CommonController.mutationFuture(
                                          eventProvider
                                              .deleteEvent(eventProvider.hostEventList[index].eventID)
                                              .then((_) {
                                            Navigator.pop(context);
                                          }),
                                          "Event successfully deleted",
                                          context);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          iconButtonOne: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          iconButtonTwo: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          titleButtonOne: str_edit,
                          titleButtonTwo: str_delete,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
