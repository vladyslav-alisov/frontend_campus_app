import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/event_screens_controllers/my_events_screen_controller.dart';
import 'package:campus_app/screens/event_screens/event_attendees_screen.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/event_widgets/CampusEventListTile.dart';
import 'package:campus_app/widgets/event_widgets/CampusMyEventsCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MyEventsPopMenuOptions { Attendees, Cancel }
enum HostEventsPopMenuOptions { Attendees, Edit, Delete }

class MyEventsScreen extends StatelessWidget {
  static const String routeName = "/my_events_screen";
  @override
  Widget build(BuildContext context) {
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    return ChangeNotifierProvider(
      create: (context) => MyEventsScreenController(),
      child: authData.socialClub == str_false ? MyEventsScaffold() : MyEventsSCOwnerScaffold(),
    );
  }
}

class MyEventsScaffold extends StatefulWidget {
  @override
  _MyEventsScaffoldState createState() => _MyEventsScaffoldState();
}

class _MyEventsScaffoldState extends State<MyEventsScaffold> {
  bool _isLoading = false;

  void setIsLoading(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void initState() {
    CommonController.queryFuture(
        Provider.of<EventsProvider>(context, listen: false).myEvents().then((_) {
          setState(() {
            _isLoading = false;
          });
        }),
        context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventsProvider>(context);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
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
            body: CampusMyEventsListView(eventProvider: eventProvider),
          );
  }
}

class MyEventsSCOwnerScaffold extends StatefulWidget {
  @override
  _MyEventsSCOwnerScaffoldState createState() => _MyEventsSCOwnerScaffoldState();
}

class _MyEventsSCOwnerScaffoldState extends State<MyEventsSCOwnerScaffold> {
  bool _isLoading = false;

  @override
  void initState() {
    CommonController.queryFuture(
        Provider.of<EventsProvider>(context, listen: false).myEvents().then((_) async  {
          await CommonController.queryFuture(Provider.of<EventsProvider>(context, listen: false).hostEvents(), context);
          setState(() {
            _isLoading = false;
          });
        }),
        context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var eventProvider = Provider.of<EventsProvider>(context);
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          labelStyle: Theme.of(context).textTheme.headline1,
                          isScrollable: false,
                          labelPadding: EdgeInsets.all(15),
                          automaticIndicatorColorAdjustment: false,
                          indicatorColor: Colors.grey,
                          tabs: [
                            Text(
                              AppLocalizations.of(context).translate(str_myEvents),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15,color: Colors.grey),
                            ),
                            Text(
                              AppLocalizations.of(context).translate(str_hosting),
                              style: TextStyle(fontSize: 15,color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  CampusMyEventsListView(eventProvider: eventProvider),
                  ListView.builder(
                    itemCount: eventProvider.hostEventList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return CampusEventListTile(
                        eventProvider.hostEventList[index],
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return List.generate(
                              HostEventsPopMenuOptions.values.length,
                              (popupindex) {
                                return PopupMenuItem(
                                  value: HostEventsPopMenuOptions.values[popupindex].index,
                                  child: Text((describeEnum(HostEventsPopMenuOptions.values[popupindex]))),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.more_vert_sharp),
                          onSelected: (value) {
                            if (value == HostEventsPopMenuOptions.Attendees.index) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EventAttendeesScreen(eventID: eventProvider.hostEventList[index].eventID)));
                            }
                            if (value == HostEventsPopMenuOptions.Delete.index) {
                              showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                  content:
                                      new Text(AppLocalizations.of(context).translate(str_warningBeforeEventDelete)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_confirm)),
                                      onPressed: () async {
                                        await CommonController.mutationFuture(
                                            eventProvider
                                                .deleteEvent(eventProvider.hostEventList[index].eventID)
                                                .then((_) {
                                              Navigator.pop(context);
                                            }),
                                            "Event successfully deleted",
                                            context);
                                        // Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (value == HostEventsPopMenuOptions.Edit.index) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventEditScreen(
                                    event: eventProvider.hostEventList[index],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}

class CampusMyEventsListView extends StatelessWidget {
  const CampusMyEventsListView({
    Key key,
    @required this.eventProvider,
  }) : super(key: key);

  final EventsProvider eventProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventProvider.myEventList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return CampusEventListTile(
          eventProvider.myEventList[index],
          PopupMenuButton(
            icon: Icon(Icons.more_vert_sharp),
            onSelected: (value) {
              if (value == MyEventsPopMenuOptions.Attendees.index) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventAttendeesScreen(eventID: eventProvider.myEventList[index].eventID)));
              }
              if (value == MyEventsPopMenuOptions.Cancel.index) {
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
                          // Navigator.of(context).pop();
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
            },
            itemBuilder: (context) {
              return List.generate(
                MyEventsPopMenuOptions.values.length,
                (index) {
                  return PopupMenuItem(
                    value: MyEventsPopMenuOptions.values[index].index,
                    child: Text((describeEnum(MyEventsPopMenuOptions.values[index]))),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
