

import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/User.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProvider with ChangeNotifier {

  var setup = GraphQLSetup();

  UserProvider(this.authData,this.user);
  AuthData authData;
  User user;

  Future<void> profile() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.profile),
      variables: {
        ConstQueryKeys.userID: authData.login.userID,
        ConstQueryKeys.typeOfUser: authData.login.typeOfUser,
      },
    );

    QueryResult result = await setup.client.value.query(options);


    print(result.exception);
    print(result.data);
    if (result.hasException) {
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      user = User.fromJson(result.data);
    }
    notifyListeners();
  }

}
