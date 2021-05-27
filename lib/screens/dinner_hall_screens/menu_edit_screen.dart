import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/menu_screens_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum MealTitles { Soup, Vegetable_Meal, White_Meat_Meal, Red_Meat_Meal, Dessert, Salad }
enum Meals { soup, redMeal, whiteMeal, vegMeal, salad, dessert }

class MenuEditScreen extends StatelessWidget {
  static const String routeName = "/menu_edit_screen";
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuEditScreenController(),
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
            Provider.of<MenuProvider>(context, listen: false).menu().then((value) =>
                CommonController.queryFuture(Provider.of<MenuProvider>(context, listen: false).meals(), context)
                    .then((_) => Provider.of<MenuEditScreenController>(context, listen: false).initVariables(value))),
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
    var screenController = Provider.of<MenuEditScreenController>(context);

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
                actionWidget: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(Icons.calendar_today_rounded, color: Colors.white),
                      dropdownColor: Theme.of(context).primaryColor,
                      items: screenController.days
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value + " ",
                                  style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 16)),
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
                ),
                title: AppLocalizations.of(context).translate(str_menu),
              ),
            ),
            body: Container()/*SingleChildScrollView(
              child: Column(
                children: List.generate(
                  MealTitles.values.length,
                      (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        dense: true,
                        title: Text(
                          describeEnum(
                            MealTitles.values[index],
                          ).replaceAll("_", " "),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                        subtitle: Text(""),
                        leading: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: //todo put image of todays menu  == null
                                  ? Image.asset(
                                  ConstAssetsPath.img_placeHolder,
                                  fit: BoxFit.fill,
                                )
                                    : NetworkImage(menuProvider.mealOptions
                                .firstWhere((element) => element.mealName == controllersList[index])
                            .mealImageUrl),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) => Container(
                      child: Center(
                        child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    ),
    ),
    ),
    ),*/
          );
  }
}
