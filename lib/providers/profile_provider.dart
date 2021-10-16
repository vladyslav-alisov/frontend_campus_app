import 'dart:io';
import 'package:campus_app/providers/user_provider.dart';

import 'package:campus_app/models/User.dart';
import 'package:campus_app/utils/exception_handler.dart';
import 'package:campus_app/utils/graph_ql_setup.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ProfileProvider with ChangeNotifier {

  var setup = GraphQLSetup();

  ProfileProvider(this.authData,this.user);
  AuthProvider authData;
  User user;

  Future<void> profile() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.profile),
      variables: {
        ConstQueryKeys.userID: authData.authData.login.userID,
        ConstQueryKeys.typeOfUser: authData.authData.login.typeOfUser,
      },
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      user = User.fromJson(result.data);
      print(result.data);
    }
    notifyListeners();
  }

}
