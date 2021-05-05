import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/menu/Menu.dart';
import 'package:campus_app/models/menu/MenuToSend.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MenuProvider with ChangeNotifier{

  MenuProvider(this.authData,this.menus,this.menuList);
  AuthData authData;

  var setup = GraphQLSetup();

  Menus menus;
  List<Menu> menuList = [];

  Future<void> createMenu(MenuToSend menu) async {
    print(menu);
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
  }
  Future<List<Menu>> menu() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.menu),
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      menus = Menus.fromJson(result.data);
      menuList = List.from(menus.menus);
    }
    return menuList;
  }

}