import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
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
    final userData = Provider.of<AuthProvider>(context, listen: false).authData;
    final eventProvider = Provider.of<EventsProvider>(context);
    final eventList = Provider.of<EventsProvider>(context, listen: false).eventList;
    final EventScreen args = ModalRoute.of(context).settings.arguments as EventScreen;
    _isJoined = eventProvider.myEventList.any((element) => element.title == eventList[args.index].title);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_eventDetails),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: eventList[args.index].imageUrl == null
                              ? Image.asset(
                                  ConstAssetsPath.img_placeholderImage,
                                  fit: BoxFit.fill,
                                )
                              : NetworkImage(eventList[args.index].imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.14), BlendMode.darken),
                          onError: (exception, stackTrace) => Container(
                            child: Center(
                              child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          eventList[args.index].title.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: Icons.people,
                                      title: AppLocalizations.of(context).translate(str_attendees),
                                      textData: eventList[args.index].attendee,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: FontAwesomeIcons.ticketAlt,
                                      title: AppLocalizations.of(context).translate(str_price),
                                      textData: eventList[args.index].price!= "Free" ? eventList[args.index].price+" TL" : eventList[args.index].price,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: Icons.calendar_today_sharp,
                                      title: AppLocalizations.of(context).translate(str_dateOfTheEvent),
                                      textData: eventList[args.index].date,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: Icons.access_time_sharp,
                                      title: AppLocalizations.of(context).translate(str_location),
                                      textData: eventList[args.index].time,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: Icons.location_on_sharp,
                                      title: AppLocalizations.of(context).translate(str_location),
                                      textData: eventList[args.index].location,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CampusIconText(
                                      icon: FontAwesomeIcons.flag,
                                      title: AppLocalizations.of(context).translate(str_socialClubs),
                                      textData: eventList[args.index].organizer,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.list_alt_outlined,size: 15,),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  AppLocalizations.of(context).translate(str_details),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            eventList[args.index].description,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                        userData.login.socialClub == eventList[args.index].organizer
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventEditScreen(
                                              event: eventProvider.eventList[args.index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(AppLocalizations.of(context).translate(str_edit)),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _isLoading
                                      ? CircularProgressIndicator()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: !_isJoined
                                              ? ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Theme.of(context).primaryColor)),
                                                  onPressed: () {
                                                    setIsLoading(true);
                                                    CommonController.mutationFuture(
                                                        eventProvider.joinEvent(eventList[args.index].eventID),
                                                        AppLocalizations.of(context).translate(str_eventAddedSuccess),
                                                        context);
                                                    setIsLoading(false);
                                                  },
                                                  child: Text(AppLocalizations.of(context).translate(str_join)),
                                                )
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Theme.of(context).primaryColor)),
                                                  onPressed: () {
                                                    setIsLoading(true);
                                                    CommonController.mutationFuture(
                                                        eventProvider.cancelEvent(eventList[args.index].eventID),
                                                        AppLocalizations.of(context).translate(str_eventRemovedSuccess),
                                                        context);
                                                    setIsLoading(false);
                                                  },
                                                  child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                                ),
                                        ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
}

class CampusIconText extends StatelessWidget {
  const CampusIconText({
    this.icon,
    this.textData,
    this.title,
  });

  final IconData icon;
  final String title;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3,
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  icon,
                  size: 15,
                ),
              ),
              Text(""),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      textData,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
