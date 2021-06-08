import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/event_detail_screen.dart';
import 'package:campus_app/screens/event_screens/my_events_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/event_widgets/CampusEventsListView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  static const routeName = '/event_screen';

  EventScreen({this.index});
  final int index;
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<EventsProvider>(context, listen: false).events().then((_) {
          Provider.of<EventsProvider>(context, listen: false).myEvents().then((_) => setState(() {
                _isLoading = false;
              }));
        }),
        context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var socialClubName = Provider.of<AuthProvider>(context, listen: false).authData.login.socialClub;
    var _eventsList = Provider.of<EventsProvider>(context).eventList;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_events),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                CustomScrollView(
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: _eventsList[index].imageUrl == null
                                                          ? Image.asset(
                                                              ConstAssetsPath.img_placeholderImage,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : NetworkImage(_eventsList[index].imageUrl),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(
                                                          Colors.black.withOpacity(0.1), BlendMode.darken),
                                                      onError: (exception, stackTrace) => Container(
                                                        child: Center(
                                                          child: Text(AppLocalizations.of(context)
                                                              .translate(str_errorLoadImage)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
              style: Theme.of(context).textTheme.headline3.copyWith(fontWeight: FontWeight.bold,fontSize: 19),
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
