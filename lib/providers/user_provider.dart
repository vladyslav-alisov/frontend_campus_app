import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/utils/exception_handler.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/utils/graph_ql_setup.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthProvider with ChangeNotifier {
  AuthData authData;
  bool isAuth = false;
  var setup = GraphQLSetup();


  Future<void> exitApp() async {
    authData = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }


  Future<void> pushStorageData(String email, String password) async {
    await SharedPreferences.getInstance().then((response) {
        response.setString(ConstQueryKeys.email, email);
        response.setString(ConstQueryKeys.password, password);
    });
  }

  Future<void> auth(String email, String password) async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.login),
      variables: {
        ConstQueryKeys.email: email,
        ConstQueryKeys.password: password,
      },
    );
    QueryResult result = await setup.client.value.query(options).timeout(Duration(seconds: 30));
    if (result.hasException) {
      print(result.exception);
        throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    else{
      if (result.data != null) {
        await pushStorageData(email, password);
        authData = AuthData.fromJson(result.data);
        print("is avatar? : ${authData.login.defaultAvatar}");
      }
    }
    notifyListeners();
  }

  Future<bool> checkUsersData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(ConstQueryKeys.email);
    final password = prefs.getString(ConstQueryKeys.password);
    if(email!=null && password!=null){
      await auth(email,password).then((_) {
        isAuth = true;
      }).catchError((e){
        isAuth = false;
      });
    }
    else isAuth = false;
    return isAuth;
  }


  void updateUrl(String imageUrl){
    authData.login.imageUrl = imageUrl;
    notifyListeners();
  }

  Future<void> uploadAvatar(File image) async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstMutation.uploadAvatar), variables: {
      ConstQueryKeys.image: await http.MultipartFile.fromPath(
        'campusImage',
        image.path,
      ),
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.typeOfUser: authData.login.typeOfUser,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
        updateUrl(result.data[ConstQueryKeys.action]);
    }
    notifyListeners();
  }

  Future<void> deleteAvatar() async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstMutation.deleteAvatar), variables: {
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.typeOfUser: authData.login.typeOfUser,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      updateUrl(result.data[ConstQueryKeys.action]);
    }
    notifyListeners();
  }

}
