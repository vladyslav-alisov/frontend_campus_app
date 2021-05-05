import 'package:campus_app/models/menu/Menu.dart';
import 'package:campus_app/models/menu/MenuToSend.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }

class MenuEditScreenController with ChangeNotifier {
  final List<String> days = [
    describeEnum(Days.Monday),
    describeEnum(Days.Tuesday),
    describeEnum(Days.Wednesday),
    describeEnum(Days.Thursday),
    describeEnum(Days.Friday),
  ];

  TextEditingController dayController;
  TextEditingController redMealController;
  TextEditingController whiteMealController;
  TextEditingController vegMealController;
  TextEditingController soupController;
  TextEditingController saladController;
  TextEditingController desertController;

  bool isLoading = false;

  void initVariables(List<Menu> menuList) {
    dayController = TextEditingController();
    dayController.text = describeEnum(Days.values[CommonController.today() - 1]);
    redMealController = TextEditingController();
    whiteMealController = TextEditingController();
    vegMealController = TextEditingController();
    soupController = TextEditingController();
    saladController = TextEditingController();
    desertController = TextEditingController();

    if (menuList != [] && menuList.isNotEmpty) {
      int initIndex = menuList.indexWhere((element) => int.parse(element.dayID) == CommonController.today() - 1);
      redMealController.text = menuList[initIndex].redMeal;
      whiteMealController.text = menuList[initIndex].whiteMeal;
      vegMealController.text = menuList[initIndex].vegMeal;
      soupController.text = menuList[initIndex].soup;
      saladController.text = menuList[initIndex].salad;
      desertController.text = menuList[initIndex].dessert;
    }
    notifyListeners();
  }

  void setMenuUpToDay(List<Menu> menuList) {
    int initIndex = menuList.indexWhere((element) =>
        element.dayID ==
        (Days.values.indexWhere((element) => element.toString() == "Days." + dayController.text) + 1).toString());
    if (initIndex != -1) {
      redMealController.text = menuList[initIndex].redMeal;
      whiteMealController.text = menuList[initIndex].whiteMeal;
      vegMealController.text = menuList[initIndex].vegMeal;
      soupController.text = menuList[initIndex].soup;
      saladController.text = menuList[initIndex].salad;
      desertController.text = menuList[initIndex].dessert;
    } else
      resetVariables();
  }

  void resetVariables() {
    redMealController.clear();
    whiteMealController.clear();
    vegMealController.clear();
    soupController.clear();
    saladController.clear();
    desertController.clear();
  }

  void setDay(String day, List<Menu> menuList) {
    dayController.text = day;
    if (menuList != []) {
      setMenuUpToDay(menuList);
    }
    notifyListeners();
  }

  void setIsLoading(bool state) {
    isLoading = state;
    notifyListeners();
  }

  MenuToSend sendMenu(BuildContext context) {
    MenuToSend menu = new MenuToSend(
      dayID: (Days.values.indexWhere((element) => element.toString() == "Days." + dayController.text) + 1).toString(),
      redMeal: redMealController.text,
      whiteMeal: whiteMealController.text,
      vegMeal: vegMealController.text,
      soup: soupController.text,
      salad: saladController.text,
      dessert: desertController.text,
    );
    return menu;
  }
}
