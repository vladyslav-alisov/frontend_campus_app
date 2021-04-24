

import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthProvider with ChangeNotifier {
  AuthData authData;

  var setup = GraphQLSetup();

  void exitApp(){
    authData = null;
    notifyListeners();
  }
  Future<void> auth(String email, String password) async {

    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.login),
      variables: {
        ConstQueryKeys.email: email,
        ConstQueryKeys.password: password,
      },
    );
    QueryResult result = await setup.client.value.query(options).timeout(Duration(seconds: 20));
    if (result.hasException) {
        throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    else{
      if (result.data != null) {
        authData = AuthData.fromJson(result.data);
      }
    }
    notifyListeners();
  }


}
