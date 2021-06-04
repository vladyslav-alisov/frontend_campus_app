import 'dart:convert';
import 'dart:io';
import 'package:campus_app/models/social_clubs/SocialClubRequestsList.dart';
import 'package:flutter/foundation.dart';
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

enum RequestStatus { non, member, wait }

class SocialClubProvider with ChangeNotifier {
  SocialClubProvider(this.authData, this.socialClubList, this.mySocialClubList, this.socialClubMembersList,
      this.galleryImagesList, this.socialClubRequestsList, this.socialClubDetail);

  var setup = GraphQLSetup();
  final AuthData authData;
  List<SocialClub> socialClubList = [];
  List<SocialClub> mySocialClubList = [];
  List<SocialClubMember> socialClubMembersList = [];
  List<Gallery> galleryImagesList = [];
  List<SocialClubRequest> socialClubRequestsList = [];
  SocialClub socialClubDetail;

  Future<void> socialClub(String scID) async {
    socialClubDetail = null;
    QueryOptions options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ConstQuery.socialClub),
        variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.scID: scID});
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      print(result.data);
      socialClubDetail = SocialClub.fromJson(result.data[ConstQueryKeys.socialClub]);
    }
    notifyListeners();
  }

  Future<void> socialClubs() async {
    socialClubList = [];
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
      print(result.data);
      socialClubList = SocialClubList.fromJson(result.data).socialClubs;
    }
    notifyListeners();
  }

  Future<void> mySocialClubs() async {
    mySocialClubList = [];
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
      throw "Oups! Something went wrong!";
    } else {
      print(result.data);
      socialClubDetail.status = describeEnum(RequestStatus.wait);
    }
    notifyListeners();
  }

  Future<void> cancelRequestJoinSocialClub(String scID) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ConstMutation.cancelRequestJoinSocialClub),
        variables: {
          ConstQueryKeys.scID: scID,
          ConstQueryKeys.userID: authData.login.userID,
        });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Oups! Something went wrong!";
    } else {
      print(result.data);
      socialClubDetail.status = describeEnum(RequestStatus.non);
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
      if (mySocialClubList.isNotEmpty) {
        mySocialClubList.removeWhere((element) => element.scID == scID);
      }
      socialClubDetail.status = describeEnum(RequestStatus.non);
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
      socialClubRequestsList = [];
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      print(result.data);
      socialClubRequestsList = SocialClubRequestsList.fromJson(result.data).socialClubRequests;
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

  Future<void> editDescriptionSocialClub(String scoID, String scID, String description) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: gql(ConstMutation.editDescriptionSocialClub),
        variables: {
          ConstQueryKeys.scID: scID,
          ConstQueryKeys.scoID: scoID,
          ConstQueryKeys.inputDescription: description,
        });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      if(socialClubDetail!=null){
      socialClubDetail.description = description;
      }
      socialClubList.firstWhere((element) => element.scID==scID).description = description;
    }
    notifyListeners();
  }

  Future<void> deleteSCMember(String scoID, String scID, String userID) async {
    MutationOptions options =
        MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.deleteSCMember), variables: {
      ConstQueryKeys.scID: scID,
      ConstQueryKeys.scoID: scoID,
      ConstQueryKeys.userID: userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      socialClubMembersList.removeWhere((element) => element.userID == userID);
      socialClubDetail = SocialClub.fromJson(result.data['action']);
    }
    notifyListeners();
  }

  Future<void> acceptJoinSocialClubMember(String scoID, String scID, String userID) async {
    //todo check why type 'bool' is not a subtype of type 'Map<dynamic, dynamic>?' in type cast), graphqlErrors: [] on IOS
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ConstMutation.acceptJoinSocialClub),
        variables: {
          ConstQueryKeys.scID: scID,
          ConstQueryKeys.scoID: scoID,
          ConstQueryKeys.userID: userID,
        });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      print(result.data);
      throw "Something went wrong";
    } else {
      print(result.data);
      socialClubRequestsList.removeWhere((element) => element.userID == userID);
      socialClubDetail = SocialClub.fromJson(result.data['action']);
    }
    notifyListeners();
  }


  Future<void> denyJoinSocialClub(String scoID, String scID, String userID) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ConstMutation.denyJoinSocialClub),
        variables: {
          ConstQueryKeys.scID: scID,
          ConstQueryKeys.scoID: scoID,
          ConstQueryKeys.userID: userID,
        });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      socialClubRequestsList.removeWhere((element) => element.userID == userID);
    }
    notifyListeners();
  }

  Future<void> gallery(String scID) async {
    galleryImagesList = [];
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
      galleryImagesList.insert(0,Gallery.fromJson(result.data['action']));
    }
    notifyListeners();
  }

  Future<void> uploadAvatarSocialClub(File image) async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.uploadAvatarSocialClub), variables: {
        ConstQueryKeys.image: await http.MultipartFile.fromPath(
          'campusImage',
          image.path,
        ),
      ConstQueryKeys.scID: socialClubDetail.scID,
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      socialClubList.firstWhere((element) => element.scID == socialClubDetail.scID).imageUrl = result.data[ConstQueryKeys.action];
      socialClubDetail.imageUrl = result.data[ConstQueryKeys.action];
    }
    notifyListeners();
  }

  Future<void> deleteAvatarSocialClub() async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.deleteAvatarSocialClub), variables: {
      ConstQueryKeys.scID: socialClubDetail.scID,
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      socialClubList.firstWhere((element) => element.scID == socialClubDetail.scID).imageUrl = result.data[ConstQueryKeys.action];
      socialClubDetail.imageUrl = result.data[ConstQueryKeys.action];
    }
    notifyListeners();
  }

  Future<void> deletePost(String postID) async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.networkOnly, document: gql(ConstMutation.deletePost), variables: {
      ConstQueryKeys.scoID: socialClubDetail.scoID,
      ConstQueryKeys.postID: postID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Something went wrong";
    } else {
      print(result.data);
      galleryImagesList.removeWhere((element) => element.postID == postID);
    }
    notifyListeners();
  }
}
