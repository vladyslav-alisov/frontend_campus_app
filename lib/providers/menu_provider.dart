import 'dart:convert';
import 'dart:developer';

import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/menu/Food.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum MealTitles { Soup, Vegetable_Meal, White_Meat_Meal, Red_Meat_Meal, Salad, Dessert }

class MenuProvider with ChangeNotifier {
  MenuProvider(this.authData, this.menuList, this.mealOptions);

  var setup = GraphQLSetup();
  AuthData authData;

  List<Menu> menuList = [];
  List<Menu> mealOptions = [];

  Future<List<Menu>> menu() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.menu),
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      menuList = Food.fromJson(result.data).menu;
    }
    notifyListeners();
    return menuList;
  }

  Future<void> meals() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.meals),
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      mealOptions = MealsList.fromJson(result.data).menu;
    }
    notifyListeners();
  }

  Future<void> chooseMeals(List<Menu> tempMenuList, int dayIndex) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.chooseMeals), variables: {
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.menuInput: {
        ConstQueryKeys.dayID: dayIndex+1,
        ConstQueryKeys.soup: tempMenuList[dayIndex].meals[0].mealID,
        ConstQueryKeys.redMeal: tempMenuList[dayIndex].meals[1].mealID,
        ConstQueryKeys.whiteMeal: tempMenuList[dayIndex].meals[2].mealID,
        ConstQueryKeys.vegMeal: tempMenuList[dayIndex].meals[3].mealID,
        ConstQueryKeys.salad: tempMenuList[dayIndex].meals[4].mealID,
        ConstQueryKeys.dessert: tempMenuList[dayIndex].meals[5].mealID,
      }
    });
    QueryResult result = await setup.client.value.mutate(options);

    if (result.hasException) {
      print(result.exception);
      throw "Oups,something went wrong";
    } else {
      menuList = List.generate(
        tempMenuList.length,
        (index) => Menu(
          sTypename: tempMenuList[index].sTypename,
          meals: List.generate(
            tempMenuList[index].meals.length,
            (index2) => tempMenuList[index].meals[index2],
          ),
        ),
      );
    }
    notifyListeners();
  }

/*Future<void> createMenu(MenuToSend menu) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: gql(ConstMutation.createMenu),
        variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.menuInput: menu.toJson()});
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not create a menu! Please try again later.";
    } else {
      Menu temp = Menu.fromJson(result.data["action"]);
      print(temp);
      menuList[menuList.indexWhere((element) => element.dayID == temp.dayID)] = temp;
    }
    notifyListeners();
  }*/

}
