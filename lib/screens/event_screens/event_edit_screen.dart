import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/event_screens_controllers/event_edit_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Options { Update, Create }
enum Attendees { Students, Stuff, All }

//todo: add attendees types

class EventEditScreen extends StatelessWidget {
  static const String routeName = "/event_edit_screen";
  EventEditScreen({this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventEditScreenController(),
      child: EventEditScaffold(existingEvent: event),
    );
  }
}




class EventEditScaffold extends StatefulWidget {
  EventEditScaffold({this.existingEvent});
  final Event existingEvent;
  @override
  _EventEditScaffoldState createState() => _EventEditScaffoldState();
}
class _EventEditScaffoldState extends State<EventEditScaffold> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Provider.of<EventEditScreenController>(context,listen: false).initVariables(widget.existingEvent);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<EventEditScreenController>(context);
    var eventProvider = Provider.of<EventsProvider>(context);
    return Scaffold(
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
          AppLocalizations.of(context).translate(str_createEvent),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampusTextInputField(
                      controller: screenController.eventTitleController,
                      hintText: "Event Name",
                      validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(
                              color: Color(0xffE1E1E1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FittedBox(
                                  child: TextButton(
                                    onPressed: () => screenController.openTimePicker(context),
                                    child: Text("Select Time", style: Theme.of(context).textTheme.headline2),
                                  ),
                                ),
                                FittedBox(child: Text(screenController.selectedTime.format(context))),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            border: Border.all(
                              color: Color(0xffE1E1E1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FittedBox(
                                  child: TextButton(
                                    onPressed: () => screenController.openDatePicker(context),
                                    child: Text(
                                      "Select Date",
                                      style: Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                ),
                                FittedBox(child: Text(screenController.dateFormat.format(screenController.selectedDate))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampusTextInputField(
                      controller: screenController.locationController,
                      hintText: "Location",
                      validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                      rightIcon: IconButton(icon: Icon(Icons.location_on_sharp)),
                      textInputType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                        border: Border.all(
                          color: Color(0xffE1E1E1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Select Attendee: "),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                items: <String>[describeEnum(Attendees.All),describeEnum(Attendees.Students),describeEnum(Attendees.Stuff)].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toSet().toList(),
                                value: screenController.attendeeController?.text,
                                onChanged: (value) {
                                  screenController.setAttendee(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CampusTextInputField(
                            controller: screenController.priceController,
                            hintText: "Price",
                            textInputType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => screenController.setEventPrice("Free"),
                            child: Text(
                              "Free",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampusTextInputField(
                      controller: screenController.descriptionController,
                      hintText: "Enter your description",
                      maxLines: 8,
                      validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(color: Color(0xffE1E1E1))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              "Choose an image:",
                              style: TextStyle(fontSize: 20, color: Colors.grey),
                            )),
                            Flexible(
                              fit: FlexFit.tight,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: GestureDetector(
                                  onTap: () => screenController.showImagePicker(context),
                                  child: screenController.image == null && widget.existingEvent == null
                                      ? Image.asset(ConstAssetsPath.img_placeHolder)
                                      : widget.existingEvent?.imageUrl == null ||screenController.image != null  ? Image.file(screenController.image) : Image.network(widget.existingEvent?.imageUrl),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: screenController.isLoading ? Container(child: Center(child: CircularProgressIndicator(),),): ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {

                        if (_formKey.currentState.validate()) {
                          screenController.setIsLoading(true);
                          if (widget.existingEvent != null) {
                            await CommonController.mutationFuture(
                                    eventProvider.editEvent(eventID: widget.existingEvent.eventID, event: screenController.sendEvent(context)).then((_) {
                                      Navigator.pop(context);
                                    }),
                                    "Event has been successfully updated",
                                    context);
                          } else {
                            await CommonController.mutationFuture(
                                eventProvider.createEvent(screenController.sendEvent(context)).then((_) {
                                  Navigator.pop(context);
                                }),
                                "Event has been successfully created",
                                context).catchError((e)=> print(e));
                          }
                          screenController.setIsLoading(false);
                        }
                      },
                      child: Text(screenController.condition),
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
}
