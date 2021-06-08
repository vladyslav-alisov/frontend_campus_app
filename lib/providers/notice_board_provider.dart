import 'dart:convert';
import 'dart:developer';

import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/notice_board/NoticeBoard.dart';
import 'package:campus_app/models/notice_board/NoticeToSend.dart';
import 'package:campus_app/utils/ExceptionHandler.dart';
import 'package:campus_app/utils/GraphQLSetup.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NoticeBoardProvider with ChangeNotifier{
  NoticeBoardProvider(this.authData,this.noticeBoardList,this.myNoticeBoardList);
  final AuthData authData;
  List<Notice> noticeBoardList=[];
  List<Notice> myNoticeBoardList = [];

  var setup = GraphQLSetup();

  Future<void> noticeList() async {
    noticeBoardList=[];
    myNoticeBoardList=[];
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.noticeList),
      variables: {ConstQueryKeys.userID: authData.login.userID},
    );
    QueryResult result = await setup.client.value.query(options);
    if (result.hasException) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result.data != null) {
      log(jsonEncode(result.data));
      noticeBoardList = NoticeBoard.fromJson(result.data).noticeList;
      myNoticeBoardList.addAll(noticeBoardList.where((element) => element.creatorUserID == authData.login.userID));
    }
    notifyListeners();
  }
  Future<void> createNotice(NoticeToSend notice) async {
    MutationOptions options = MutationOptions(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
        document: gql(ConstMutation.createNotice),
        variables: {ConstQueryKeys.userID: authData.login.userID, ConstQueryKeys.noticeInput: await notice.toJson()});
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not create a post! Please try again later.";
    } else {
      print(result.data);
      noticeBoardList.insert(0, Notice.fromJson(result.data[ConstQueryKeys.action]));
      myNoticeBoardList.insert(0,Notice.fromJson(result.data[ConstQueryKeys.action]));
    }
    notifyListeners();
  }

  Future<void> editNotice({String noticeID, NoticeToSend notice}) async {
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstMutation.editNotice), variables: {
      ConstQueryKeys.userID: authData.login.userID,
      ConstQueryKeys.noticeID: noticeID,
      ConstQueryKeys.noticeInput: await notice.toJson(),
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not update a post! Please try again later.";
    } else {
      print(result.data);
      noticeBoardList[noticeBoardList.indexWhere((element) => element.noticeID == noticeID)] = Notice.fromJson(result.data[ConstQueryKeys.action]);
      myNoticeBoardList[myNoticeBoardList.indexWhere((element) => element.noticeID == noticeID)] =
            Notice.fromJson(result.data[ConstQueryKeys.action]);

    }
    notifyListeners();
  }
  Future<void> deleteNotice(String noticeID) async {
    //todo implement optimistic result
    MutationOptions options =
    MutationOptions(fetchPolicy: FetchPolicy.cacheAndNetwork, document: gql(ConstMutation.deleteNotice), variables: {
      ConstQueryKeys.noticeID: noticeID,
      ConstQueryKeys.userID: authData.login.userID,
    });
    QueryResult result = await setup.client.value.mutate(options);
    if (result.hasException) {
      print(result.exception);
      throw "Could not delete event! Please try again.";
    } else {
      print(result.data);
      myNoticeBoardList.removeWhere((element) => element.noticeID == noticeID);
      noticeBoardList.removeWhere((element) => element.noticeID == noticeID);
    }
    notifyListeners();
  }

  Future<void> sendTranscriptRequest(String emailTo,String noticeTitle) async {
    final Email email = Email(
      subject: noticeTitle,
      recipients: [emailTo],
      cc: [],
      bcc: [],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }
}