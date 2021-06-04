import 'dart:convert';

import 'package:campus_app/models/menu/Food.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum MealTitles { Soup, Vegetable_Meal, White_Meat_Meal, Red_Meat_Meal, Salad, Dessert }

class MenuEditScreenController with ChangeNotifier {
  int chosenDay;
  List<Menu> tempMenuList = [];

  final List<String> days = [
    describeEnum(Days.Monday),
    describeEnum(Days.Tuesday),
    describeEnum(Days.Wednesday),
    describeEnum(Days.Thursday),
    describeEnum(Days.Friday),
  ];

  bool isLoading = false;

  void initVariables(List<Menu> menuList) {
    copyList(menuList);
    chosenDay = CommonController.today() - 1;
    notifyListeners();
  }

  void onDayChange(List<Menu> menuList, int dayIndex, BuildContext context) {
    if (!listsEqualDay(menuList, dayIndex)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text("Change Day?"),
          content: Text("All unsaved changes will be canceled."),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Stay",
              ),
            ),
            MaterialButton(
              onPressed: () async {},
              child: Text(
                "Change Day",
              ),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  void setDay(int index) {
    chosenDay = index;
    notifyListeners();
  }

  bool listsEqual(List<Menu> menuList) {
    for (int i = 0; i < menuList.length; i++) {
      for (int j = 0; j < menuList[0].meals.length; j++) {
        if (menuList[i].meals[j].mealID != tempMenuList[i].meals[j].mealID) {
          return false;
        }
      }
    }
    return true;
  }

  bool listsEqualDay(List<Menu> menuList, int dayIndex) {
    for (int i = 0; i < menuList[dayIndex].meals.length; i++) {
      if (menuList[dayIndex].meals[i].mealID != tempMenuList[dayIndex].meals[i].mealID) {
        print("lists not equal");
        return false;
      }
    }
    return true;
  }

  void copyList(List<Menu> menuList) {
    tempMenuList = List.generate(
      menuList.length,
      (index) => Menu(
        sTypename: menuList[index].sTypename,
        meals: List.generate(
          menuList[index].meals.length,
          (index2) => menuList[index].meals[index2],
        ),
      ),
    );
    notifyListeners();
  }

  void updateTempMenuList(Meal meal, int mealIndex, int dayIndex) {
    tempMenuList[dayIndex].meals[mealIndex] = meal;
    notifyListeners();
  }

  void setIsLoading(bool state) {
    isLoading = state;
    notifyListeners();
  }
}
