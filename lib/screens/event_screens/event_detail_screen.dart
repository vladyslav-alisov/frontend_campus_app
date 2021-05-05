import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/event_screens/event_edit_screen.dart';
import 'package:campus_app/screens/event_screens/events_screen.dart';
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

    final userData = Provider.of<UserProvider>(context, listen: false).authData;
    final eventProvider = Provider.of<EventsProvider>(context);
    final eventList = Provider.of<EventsProvider>(context, listen: false).eventList;
    final EventScreen args = ModalRoute.of(context).settings.arguments as EventScreen;
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
                  AspectRatio(
                    aspectRatio: 2,
                    child: eventList[args.index].imageUrl.contains("cloudinary")
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
                              placeholder: AssetImage(ConstAssetsPath.img_placeHolder),
                              image: NetworkImage(eventList[args.index].imageUrl),
                            ),
                          )
                        : Image.asset(
                            ConstAssetsPath.img_placeHolder,
                            fit: BoxFit.cover,
                          ),
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
                              Flexible(
                                child: Text(
                                  eventList[args.index].title.toUpperCase(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconText(
                                        icon: FontAwesomeIcons.flag,
                                        text: eventList[args.index].organizer,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconText(
                                        icon: Icons.calendar_today_sharp,
                                        text: eventList[args.index].date,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconText(
                                        icon: Icons.access_time_sharp,
                                        text: eventList[args.index].time,
                                      )),
                                ],
                              ),
                            ),
                            //Spacer(),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconText(
                                        icon: FontAwesomeIcons.ticketAlt,
                                        text: eventList[args.index].price,
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: IconText(
                                        icon: Icons.location_on_sharp,
                                        text: "Event by ${eventList[args.index].location}",
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Details",
                                style: TextStyle(fontSize: 20),
                              ),
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
                                        child: Text("Edit"),
                                      )),
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
                                                  onPressed: (){
                                                    setIsLoading(true);
                                                    CommonController.mutationFuture(
                                                        eventProvider.joinEvent(eventList[args.index].eventID),
                                                        "Event was successfully added",
                                                        context);
                                                    setIsLoading(false);
                                                  },
                                                  child: Text("Join"),
                                                )
                                              : ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(Theme.of(context).primaryColor)),
                                                  onPressed: () {
                                                    setIsLoading(true);
                                                    CommonController.mutationFuture(
                                                        eventProvider.cancelEvent(eventList[args.index].eventID),
                                                        "Event successfully removed from your events",
                                                        context);
                                                    setIsLoading(false);
                                                  },
                                                  child: Text("Cancel"),
                                                )),
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
}

class IconText extends StatelessWidget {
  IconText({this.icon, this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Icon(icon, size: Theme.of(context).textTheme.bodyText2.fontSize),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(flex: 10,child: Text(text, style: Theme.of(context).textTheme.bodyText2,overflow: TextOverflow.ellipsis,maxLines: 2,softWrap: false,)),
      ],
    );
  }
}
