import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
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

  @override
  void initState() {
    _isLoading = true;
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    if (authData.sco) {
      Provider.of<EventsProvider>(context, listen: false).hostEvents().catchError((e) {
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
      });
    }
    Provider.of<EventsProvider>(context, listen: false).myEvents().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventsProvider>(context);
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    if (!_isLoading) {
      return !authData.sco
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
                            content:
                            new Text(AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
                            actions: <Widget>[
                              TextButton(
                                child: Text(AppLocalizations.of(context).translate(str_yes)),
                                onPressed: () async {
                                  await future(
                                      eventProvider.cancelEvent(eventProvider.myEventList[index].eventID),
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
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        AppLocalizations.of(context).translate(str_hosting),
                        style: TextStyle(fontSize: 20),
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
                                        await future(
                                            eventProvider.cancelEvent(eventProvider.myEventList[index].eventID),
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
                                        await future(
                                            eventProvider.deleteEvent(eventProvider.hostEventList[index].eventID),
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
                            titleButtonOne: AppLocalizations.of(context).translate(str_edit),
                            titleButtonTwo: AppLocalizations.of(context).translate(str_delete),
                          );
                        }),
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

/*  "Event was successfully removed."*/
  /*eventProvider
                        .cancelEvent(eventProvider.myEventList[index].eventID)*/
  _showMaterialDialog(Future<void> futureFunc, String warningMsg) async {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
        content: new Text(warningMsg),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).translate(str_yes)),
            onPressed: () {
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
  }
}
