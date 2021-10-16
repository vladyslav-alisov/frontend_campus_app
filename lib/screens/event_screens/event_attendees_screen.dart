import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/general_widgets/CampusPersonListTile.dart';
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
        _isLoading = false; //false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eventsProvider = Provider.of<EventsProvider>(context, listen: false);
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
                title: AppLocalizations.of(context).translate(str_listOfAttendees),
              ),
            ),
            body: eventsProvider.attendeeList.length == 0
                ? Center(
                    child: Text("No attendees were found"),
                  )
                : ListView.builder(
                    itemCount: eventsProvider.attendeeList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CampusPersonListTile(
                            surname: eventsProvider.attendeeList[index].surname,
                            name: eventsProvider.attendeeList[index].name,
                            imageUrl: eventsProvider.attendeeList[index].imageUrl),
                      );
                    },
                  ),
          );
  }
}
