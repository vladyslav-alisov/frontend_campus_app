
import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/notice_board/NoticeBoard.dart';
import 'package:campus_app/utils/exception_handler.dart';
import 'package:campus_app/utils/graph_ql_setup.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
//todo: auth.login.userID to graphql token!!!
class NoticeBoardApi{

  var setup = GraphQLSetup();

  Future<List<Notice>> getNoticeList(AuthData authData) async {
    List<Notice> data = [];
    QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(ConstQuery.noticeList),
      variables: {ConstQueryKeys.userID: authData.login.userID},
    );
    QueryResult result = await setup.client.value.query(options);
    if (result?.hasException ?? true) {
      print(result.exception);
      throw ExceptionHandle.errorTranslate(exception: result.exception);
    }
    if (result?.data != null) {
      data = NoticeBoard.fromJson(result.data).noticeList;
    }
    return data;
  }


}