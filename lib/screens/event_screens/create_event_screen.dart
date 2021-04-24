import 'dart:convert';
import 'dart:io';

import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventScreen extends StatefulWidget {
  static const String routeName = "/create_event_screen";
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final dateFormatToSend = DateFormat("dd.MM.yyyy");
  TextEditingController eventNameController;
  TextEditingController priceController;
  TextEditingController locationController;
  TextEditingController descriptionController;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  String _base64String = "";
  File _image;
  bool stepsCompleted = false;
  final _picker = ImagePicker();

  Future<void> _openTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime,
      context: context,
    );
    if (selectedTime != picked && picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _openDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale: Locale.fromSubtags(languageCode: "tr"),
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 1,
      ),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    descriptionController = new TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    eventNameController = new TextEditingController();
    priceController = new TextEditingController();
    locationController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: eventNameController,
                      hintText: "Event Name",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate(str_enterSomeText);
                        }
                        return null;
                      },
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
                                    onPressed: () => _openTimePicker(context),
                                    child: Text(
                                      "Select Time",
                                    ),
                                  ),
                                ),
                                FittedBox(child: Text(selectedTime.format(context))),
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
                                    onPressed: () => _openDatePicker(context),
                                    child: Text("Select Date"),
                                  ),
                                ),
                                FittedBox(child: Text(dateFormatToSend.format(selectedDate))),
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
                      controller: locationController,
                      hintText: "Location",
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate(str_enterSomeText);
                        }
                        return null;
                      },
                      rightIcon: IconButton(icon: Icon(Icons.location_on_sharp)),
                      textInputType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampusTextInputField(
                      controller: priceController,
                      hintText: "Price",
                      textInputType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CampusTextInputField(
                      controller: descriptionController,
                      hintText: "Enter your description",
                      maxLines: 8,
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).translate(str_enterSomeText);
                        }
                        return null;
                      },
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
                                  onTap: () => _showImagePicker(context),
                                  child: _base64String == ""
                                      ? Image.asset(ConstAssetsPath.img_placeHolder)
                                      : Image.memory(base64Decode(_base64String)),
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
                    child: ElevatedButton(
                      onPressed: () {
                        eventProvider
                            .createEvent(
                              title: eventNameController.text,
                              description: descriptionController.text,
                              atendee: "Not defined",
                              price: priceController.text,
                              date: selectedDate.toString(),
                              time: selectedTime.format(context),
                              location: locationController.text,
                              imageUrl: _image?.path ?? "",
                            )
                            .then(
                              (_) => ScaffoldMessenger.of(context).showSnackBar(
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
                                  content: Text("Event was successfully created."),
                                ),
                              ),
                            )
                            .then((value) => Navigator.pop(context))
                            .catchError((e) {
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
                      },
                      child: Text("Create Event"),
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

  Future getImage(bool choice) async {
    var pickedFile;
    if (choice) {
      pickedFile =
          await _picker.getImage(source: ImageSource.camera, maxWidth: 200, maxHeight: 200).catchError((e) => print(e));
    } else if (!choice) {
      pickedFile = await _picker
          .getImage(source: ImageSource.gallery, maxWidth: 200, maxHeight: 200)
          .catchError((e) => print(e));
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image.readAsBytesSync();
        _base64String = base64Encode(_image.readAsBytesSync());
      } else {
        print('No image selected.');
      }
    });
  }

  void _showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      getImage(false);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
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
