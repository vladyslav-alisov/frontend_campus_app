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

class _EventScreenState extends State<EventScreen>{
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  List<Event> _searchResult = [];

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<EventsProvider>(context, listen: false).events().then((_) {
          setState(() {
            _isLoading = false;
          });
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
          title: MyConstants.funcTitles[5],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: titleRow(context),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index){
                              return Card(
                                child: GestureDetector(
                                   onTap: () {
                                     Navigator.pushNamed(context, EventDetailScreen.routeName,
                                         arguments: EventScreen(index: index));
                                   },
                                  child: ListTile(
                                    dense: true,
                                    title: Column(
                                      children: [
                                        Text(_eventsList[index].title,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.headline5,),
                                        Divider(color: Colors.black,)
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.event,color: Colors.grey),
                                                  SizedBox(width: 5,),
                                                  Text(_eventsList[index].date)
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.access_time,color: Colors.grey),
                                                  SizedBox(width: 5,),
                                                  Text(_eventsList[index].time)
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    isThreeLine: true,
                                    trailing: Icon(FontAwesomeIcons.arrowAltCircleRight),
                                    leading: _eventsList[index].imageUrl.contains("cloudinary")
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
                                      image: NetworkImage(_eventsList[index].imageUrl),
                                    )
                                        : Image.asset(
                                      ConstAssetsPath.img_placeHolder,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          childCount: _eventsList.length,
                        ),
                      )
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
          ),
    );
  }

  Row titleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context).translate(str_upcomingEvents),
            style: Theme.of(context).textTheme.headline3,
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
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  void onSearchButtonTap(String text) async {
    List<Event> _eventsList = [];
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
}
