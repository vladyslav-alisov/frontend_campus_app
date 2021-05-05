import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/menu/Menu.dart';
import 'package:campus_app/models/menu/MenuToSend.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MenuProvider with ChangeNotifier{

  MenuProvider(this.authData);
  AuthData authData;
  var setup = GraphQLSetup();

  Future<void> createMenu(MenuToSend menu) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: gql(ConstMutation.createMenu),
        variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.menuInput: menu.toJson()});
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not create a menu! Please try again later.";
    } else {
      print(result.data);
      //eventList.add(Event.fromJson(result.data["action"]));
    }
    notifyListeners();
  }

}