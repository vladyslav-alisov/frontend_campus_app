import 'dart:io';

import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/models/events/EventToSend.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

enum Options { Update, Create }
enum AttendeeTypes { All, Students, Staff, Club_members}

class EventEditScreenController with ChangeNotifier {
  final dateFormat = DateFormat("yyyy-MM-dd");
  final picker = ImagePicker();

  TextEditingController eventTitleController;
  TextEditingController locationController;
  TextEditingController priceController;
  TextEditingController descriptionController;
  TextEditingController attendeeController;

  DateTime selectedDate;
  TimeOfDay selectedTime;
  bool isFree = false;
  File image;
  String condition;
  bool isLoading = false;

  void initVariables(Event event) async {
    eventTitleController = TextEditingController();
    locationController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    attendeeController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    isFree = false;

    if (event != null) {
      condition = describeEnum(Options.Update);
      eventTitleController.text = event.title;
      locationController.text = event.location;
      event.attendee != describeEnum(AttendeeTypes.All) &&
              event.attendee != describeEnum(AttendeeTypes.Staff) &&
              event.attendee != describeEnum(AttendeeTypes.Students)
          ? attendeeController.text = describeEnum(AttendeeTypes.All)
          : attendeeController.text = event.attendee;

      priceController.text = event.price.toLowerCase() != "free" ?  event.price : "Free";
      priceController.text == "Free" ? isFree = true : isFree = false;

      descriptionController.text = event.description;
      selectedDate = dateFormat.parse(event.date);
      selectedTime = TimeOfDay(hour: int.parse(event.time.split(":")[0]), minute: int.parse(event.time.split(":")[1]));
    } else {
      condition = describeEnum(Options.Create);
      attendeeController.text = describeEnum(AttendeeTypes.All);
    }
  }

  void showUploadImage(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(AppLocalizations.of(context).translate(str_uploadImageWarn)),
      ),
    );
  }

  void changeIsFree(){
    isFree = !isFree;
    isFree ? priceController.text = "Free": priceController.clear();
    notifyListeners();
  }

  EventToSend sendEvent(BuildContext context) {
    EventToSend event = new EventToSend(
        title: eventTitleController.text,
        time: selectedTime.format(context),
        date: dateFormat.format(selectedDate),
        location: locationController.text,
        price: priceController.text,
        description: descriptionController.text,
        imageUrl: image,
        attendee: returnAttendeeTypeID(attendeeController.text));

    return event;
  }

  int returnAttendeeTypeID(String attendee){
    int temp=0;
    AttendeeTypes.values.forEach((element) {if(element.toString().replaceAll("AttendeeTypes.","")==attendee){
      temp = element.index;
    }});
    return temp+1;
  }
  void setAttendee(String attendee) {
    attendeeController.text = attendee;
    notifyListeners();
  }

  void setEventPrice(String price) {
    priceController.text = price;
    notifyListeners();
  }

  void setIsLoading(bool state) {
    isLoading = state;
    notifyListeners();
  }

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 1,
      ),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    notifyListeners();
  }


  Future<void> openTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      initialTime: selectedTime,
      context: context,
    );
    if (selectedTime != picked && picked != null) {
      selectedTime = picked;
    }
    notifyListeners();
  }

  Future getImage(bool choice) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800).catchError((e) => print(e));
    } else if (!choice) {
      pickedFile = await picker.getImage(source: ImageSource.gallery, maxWidth: 600, maxHeight: 800).catchError((e) {
        print(e);
      });
    }

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    notifyListeners();
  }

  void showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(AppLocalizations.of(context).translate(str_photoLibrary)),
                    onTap: () {
                      getImage(false);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(AppLocalizations.of(context).translate(str_camera)),
                  onTap: () {
                    getImage(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
