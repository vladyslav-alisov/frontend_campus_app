import 'package:campus_app/models/events/AttendeeData.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventAttendeesScreen extends StatefulWidget {
  static const routeName = "/event_attendees";
  EventAttendeesScreen({this.eventID});
  final String eventID;
  @override
  _EventAttendeesScreenState createState() => _EventAttendeesScreenState();
}

class _EventAttendeesScreenState extends State<EventAttendeesScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
            Provider.of<EventsProvider>(context, listen: false).listOfAttendees(widget.eventID), context)
        .then((value) {
      setState(() {
        _isLoading = false;//false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventsProvider = Provider.of<EventsProvider>(context,listen: false);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: "List of Attendees",
        ),
      ),
            body: ListView.builder(
              itemCount: eventsProvider.attendeeList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AttendeeListTile(surname: eventsProvider.attendeeList[index].surname,name: eventsProvider.attendeeList[index].name),
                );
              },
            ),
          );
  }
}

class AttendeeListTile extends StatelessWidget {
  AttendeeListTile({this.imageUrl, this.name, this.surname});

  final String imageUrl;
  final String name;
  final String surname;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,

        radius: 35,
        child: Text("${name[0].toUpperCase()}${surname[0].toUpperCase()}",style: TextStyle(color: Colors.white),),
      ),
      title: Text("$name $surname"),
    );
  }
}
