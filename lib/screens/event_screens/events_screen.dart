import 'package:campus_app/models/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screens/event_screens/create_event_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusEventsListView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/event_screen';

  EventScreen({this.index});
  final int index;
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  List<Event> _searchResult = [];
  List<Event> _eventsList = [];

  void onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _eventsList.forEach((Event data) {
      if (data.location.toUpperCase().contains(text.toUpperCase()) ||
          data.date.toUpperCase().contains(text.toUpperCase()) ||
          data.description.toUpperCase().contains(text.toUpperCase()) ||
          data.title.toUpperCase().contains(text.toUpperCase()) ||
          data.organizer.toUpperCase().contains(text.toUpperCase())) {
        _searchResult.add(data);
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.clear();

    super.dispose();
  }

  @override
  void initState() {
    _isLoading = true;
    Provider.of<EventsProvider>(context, listen: false).events().then((_) {
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
    var authData = Provider.of<AuthProvider>(context, listen: false).authData.login;
    _eventsList = Provider.of<EventsProvider>(context).eventList;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CapmusAppBar(
          title: MyConstants.funcTitles[5],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      searchBar(context),
                      titleRow(context),
                      Expanded(
                        child: _searchController.text.isNotEmpty || _searchResult.length != 0
                            ? ListView.builder(
                                itemCount: _searchResult?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final int count = _searchResult.length > 10 ? 10 : _searchResult.length;
                                  return EventsListView(
                                    callback: () {},
                                    event: _searchResult[index],
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: _eventsList?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return EventsListView(
                                    callback: () {
                                      Navigator.pushNamed(context, EventDetailScreen.routeName,
                                          arguments: EventScreen(index: index));
                                    },
                                    event: _eventsList[index],
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                authData.sco
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            foregroundColor: Colors.black,
                            onPressed: () {
                              Navigator.pushNamed(context, CreateEventScreen.routeName);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : null,
              ],
            ),
    );
  }

  Padding titleRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate(str_upcomingEvents),
            style: Theme.of(context).textTheme.headline3,
          ),
          OutlinedButton(
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
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ],
      ),
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                _searchController.clear();
                                onSearchTextChanged(
                                  '',
                                );
                              },
                            )
                          : null,
                      //prefixIcon: Icon(Icons.search),
                      hintText: AppLocalizations.of(context).translate(str_search),
                    ),
                    onChanged: onSearchTextChanged,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.4), offset: const Offset(0, 2), blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search, size: 20, color: Colors.white), //Theme.of(context).backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
