import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/event_screen';

  EventScreen({this.index});
  final int index;
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isLoading = false;
  SearchBar searchBar;
  List<Event> eventList = [];

  _EventScreenState() {
    searchBar = new SearchBar(
      inBar: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      onCleared: () {},
      onClosed: () {
        print("closed");
      },
    );
  }

  void onSubmitted(String value) {}

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text(
        AppLocalizations.of(context).translate(str_events),
        style: Theme.of(context).textTheme.headline1,
      ),
      actions: [searchBar.getSearchAction(context)],
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
    );
  }

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<EventsProvider>(context, listen: false).events().then(
          (_) {
            Provider.of<EventsProvider>(context, listen: false).myEvents().then(
              (_) {
                if (this.mounted) {
                  setState(
                    () {
                      _isLoading = false;
                    },
                  );
                }
              },
            );
          },
        ),
        context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socialClubName = Provider.of<AuthProvider>(context, listen: false).authData.login.socialClub;
    var _eventsList = Provider.of<EventsProvider>(context).eventList;
    return Scaffold(
      appBar: searchBar.build(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                _eventsList.length != 0
                    ? CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: titleRow(context),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, EventDetailScreen.routeName,
                                            arguments: EventScreen(index: index));
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 4,
                                        child: Container(
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0, 5), // changes position of shadow
                                            ),
                                          ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 3,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: _eventsList[index].imageUrl,
                                                        imageBuilder: (context, imageProvider) {
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                                colorFilter: ColorFilter.mode(
                                                                    Colors.black.withOpacity(0.2), BlendMode.darken),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        placeholder: (context, url) =>
                                                            Center(child: CircularProgressIndicator()),
                                                        errorWidget: (context, url, error) {
                                                          return Container(
                                                            child: Center(
                                                              child: Text(
                                                                AppLocalizations.of(context)
                                                                    .translate(str_errorLoadImage),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              _eventsList[index].date,
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 6,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  _eventsList[index].title.toUpperCase(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .headline5
                                                                      .copyWith(fontSize: 12, color: Colors.black),
                                                                ),
                                                                Text(
                                                                  _eventsList[index].location.toUpperCase(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .headline5
                                                                      .copyWith(fontSize: 10),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              _eventsList[index].time,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Icon(Icons.arrow_forward_ios_outlined),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: _eventsList.length,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        child: Center(
                          child: Text("No events were found"),
                        ),
                      ),
                socialClubName != str_false
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: FloatingActionButton(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, EventEditScreen.routeName);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }

  Row titleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context).translate(str_upcomingEvents),
              style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
        ),
        Flexible(
          child: OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, MyEventsScreen.routeName);
            },
            child: Text(
              AppLocalizations.of(context).translate(str_myEvents),
              style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
