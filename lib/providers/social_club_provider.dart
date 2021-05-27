import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/social_clubs/GalleryList.dart';
import 'package:campus_app/models/social_clubs/SocialClubList.dart';
import 'package:campus_app/models/social_clubs/SocialClubMembersList.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SocialClubProvider with ChangeNotifier {
  SocialClubProvider(
      this.authData, this.socialClubList, this.mySocialClubList, this.socialClubMembersList, this.galleryImagesList);

  var setup = GraphQLSetup();
  final AuthData authData;
  List<SocialClub> socialClubList = [];
  List<SocialClub> mySocialClubList = [];
  List<SocialClubMember> socialClubMembersList = [];
  List<Gallery> galleryImagesList = [];

  Future<void> socialClubs() async {
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      document: gql(ConstQuery.socialClubs),
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      socialClubList = SocialClubList.fromJson(result.data).socialClubs;
      print(socialClubList);
    }
    notifyListeners();
  }

  Future<void> mySocialClubs() async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstQuery.mySocialClubs), variables: {
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      mySocialClubList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      mySocialClubList = MySocialClubsList.fromJson(result.data).socialClubs;
      print(mySocialClubList);
    }
    notifyListeners();
  }

  Future<void> sendRequestJoinSocialClub(String scID) async {
    print(scID);
    print(authData.login.userID);
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ConstMutation.sendRequestJoinSocialClub),
        variables: {
          ConstQueryKeys.scID: scID,
          ConstQueryKeys.userID: authData.login.userID,
        });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could join Social Club! Please try again.";
    } else {
      print(result.data);
    }
    notifyListeners();
  }

  Future<void> socialClubRequests() async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstQuery.socialClubRequests), variables: {
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      print(jsonEncode(result.data));
    }
    notifyListeners();
  }

  Future<void> socialClubMembers(String scID) async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstQuery.socialClubMembers), variables: {
      ConstQueryKeys.scID: scID,
    });
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      socialClubMembersList = [];
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      socialClubMembersList = SocialClubMembersList.fromJson(result.data).socialClubMembers;
    }
    notifyListeners();
  }

  Future<void> quitSocialClub(String scID) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.quitSocialClub), variables: {
      ConstQueryKeys.scID: scID,
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      mySocialClubList.removeWhere((element) => element.scID == scID);
    }
    notifyListeners();
  }

  Future<void> gallery(String scID) async {
    QueryOptions options =
        QueryOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstQuery.gallery), variables: {
      ConstQueryKeys.scID: scID,
    });
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      galleryImagesList = [];
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      galleryImagesList = GalleryList.fromJson(result.data).gallery;
    }
    notifyListeners();
  }

  Future<void> uploadPost(String scID, String scoID, File image, String description) async {
    print(image);
    print(await http.MultipartFile.fromPath(
      'campusImage',
      image.path,
    ));
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.uploadPost), variables: {
      ConstQueryKeys.postInput: {
        ConstQueryKeys.image: await http.MultipartFile.fromPath(
          'campusImage',
          image.path,
        ),
        ConstQueryKeys.description: description,
      },
      ConstQueryKeys.scID: scID,
      ConstQueryKeys.scoID: scoID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
    }
    notifyListeners();
  }
}
