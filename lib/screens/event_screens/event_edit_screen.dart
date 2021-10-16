import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/event_screens_controllers/event_edit_screen_controller.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Options { Update, Create }
enum Attendees {All, Students, Staff, Club_members}

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
    Provider.of<EventEditScreenController>(context, listen: false).initVariables(widget.existingEvent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<EventEditScreenController>(context);
    var eventProvider = Provider.of<EventsProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context)
              .translate(screenController.condition == str_update ? str_editEvent : str_createEvent),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              //todo: add focus if validator works
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: screenController.eventTitleController,
                    hintText: AppLocalizations.of(context).translate(str_eventName),
                    labelText: AppLocalizations.of(context).translate(str_eventName),
                    rightIcon: IconButton(icon: Icon(Icons.drive_file_rename_outline)),
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: screenController.locationController,
                    hintText: AppLocalizations.of(context).translate(str_location),
                    labelText: AppLocalizations.of(context).translate(str_location),
                    validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                    rightIcon: IconButton(icon: Icon(Icons.location_on_sharp)),
                    textInputType: TextInputType.streetAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => screenController.openTimePicker(context),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Builder(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                screenController.selectedTime.format(context).toString(),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            );
                          },
                        ),
                        CampusTextInputField(
                          rightIcon: IconButton(
                            icon: Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                          ),
                          labelText: "Time",
                          isDisable: false,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => screenController.openDatePicker(context),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Builder(
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                screenController.dateFormat.format(screenController.selectedDate),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            );
                          },
                        ),
                        CampusTextInputField(
                          rightIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          labelText: "Date",
                          isDisable: false,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CampusTextInputField(
                        isDisable: !screenController.isFree,
                        suffixText: "TL",
                        controller: screenController.priceController,
                        hintText: AppLocalizations.of(context).translate(str_price),
                        labelText: AppLocalizations.of(context).translate(str_price),
                        rightIcon: IconButton(
                          icon: Icon(Icons.monetization_on),
                        ),
                        textInputType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              AppLocalizations.of(context).translate(str_isFree),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Checkbox(
                              value: screenController.isFree,
                              onChanged: (value) {
                                screenController.changeIsFree();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: Color(0xffE1E1E1),
                          ),
                        ),
                        labelText: "Attendee",
                      ),
                      isExpanded: true,
                      items: <String>[
                        describeEnum(Attendees.All),
                        describeEnum(Attendees.Students),
                        describeEnum(Attendees.Staff),
                        describeEnum(Attendees.Club_members),
                      ]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.replaceAll("_", " ")),
                        );
                      })
                          .toSet()
                          .toList(),
                      value: screenController.attendeeController?.text,
                      onChanged: (value) {
                        screenController.setAttendee(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CampusTextInputField(
                    controller: screenController.descriptionController,
                    hintText: AppLocalizations.of(context).translate(str_enterDescription),
                    labelText: AppLocalizations.of(context).translate(str_enterDescription),
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
                            "${AppLocalizations.of(context).translate(str_chooseAnImage)}:",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )),
                          Flexible(
                            fit: FlexFit.tight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: GestureDetector(
                                onTap: () => screenController.showImagePicker(context),
                                child: screenController.image == null && widget.existingEvent == null
                                    ? Image.asset(ConstAssetsPath.img_placeholderImage)
                                    : widget.existingEvent?.imageUrl == null || screenController.image != null
                                        ? Image.file(screenController.image)
                                        : Image.network(widget.existingEvent?.imageUrl),
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
                  child: screenController.isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              screenController.setIsLoading(true);
                              if (widget.existingEvent != null) {
                                await CommonController.mutationFuture(
                                    eventProvider
                                        .editEvent(
                                            eventID: widget.existingEvent.eventID,
                                            event: screenController.sendEvent(context))
                                        .then((_) {
                                      Navigator.pop(context);
                                    }),
                                    AppLocalizations.of(context).translate(str_eventUpdatedSuccess),
                                    context);
                              } else {
                                if (screenController.image == null) {
                                  screenController.showUploadImage(context);
                                } else {
                                  await CommonController.mutationFuture(
                                          eventProvider.createEvent(screenController.sendEvent(context)).then((_) {
                                            Navigator.pop(context);
                                          }),
                                          AppLocalizations.of(context).translate(str_eventCreatedSuccess),
                                          context)
                                      .catchError((e) => print(e));
                                }
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
    );
  }
}
