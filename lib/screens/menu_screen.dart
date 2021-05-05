import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/menu_screens_controllers/menu_edit_controller_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusTextInputField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }

class MenuEditScreen extends StatelessWidget {
  static const String routeName = "/menu_screen";
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuScreenController(),
      child: MenuScreenEditScaffold(),
    );
  }
}

class MenuScreenEditScaffold extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreenEditScaffold> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
            Provider.of<MenuProvider>(context, listen: false)
                .menu()
                .then((value) => Provider.of<MenuScreenController>(context, listen: false).initVariables(value)),
            context)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);
    var screenController = Provider.of<MenuScreenController>(context);

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
              child: CapmusAppBar(
                title: MyConstants.funcTitles[5],
              ),
            ),
            //todo: add icons
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
                                  Text("Select Day: "),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      items: screenController.days
                                          .map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          })
                                          .toSet()
                                          .toList(),
                                      value: screenController.dayController?.text,
                                      onChanged: (value) {
                                        screenController.setDay(value, menuProvider.menuList);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text("Soup"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.soupController,
                            hintText: "Soup",
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                            //rightIcon: IconButton(icon: Icon(FontAwesomeIcons.food)),
                          ),
                        ),
                        Text("Meals"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.vegMealController,
                            hintText: "Vegetable meal",
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.whiteMealController,
                            hintText: "White Meat Meal",
                            maxLines: 1,
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.redMealController,
                            hintText: "Red Meat Meal",
                            maxLines: 1,
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                          ),
                        ),
                        Text("Desert-Salad"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.desertController,
                            hintText: "Desert",
                            maxLines: 1,
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CampusTextInputField(
                            controller: screenController.saladController,
                            hintText: "Salad",
                            maxLines: 1,
                            validatorErrorMsg: AppLocalizations.of(context).translate(str_enterSomeText),
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
                                      await CommonController.mutationFuture(
                                          menuProvider.createMenu(screenController.sendMenu(context)),
                                          "${screenController.dayController.text} menu has been successfully updated",
                                          context);
                                      screenController.setIsLoading(false);
                                    }
                                  },
                                  child: Text("Save"),
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
