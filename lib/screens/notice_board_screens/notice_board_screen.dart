import 'package:campus_app/models/notice_board/NoticeBoard.dart';
import 'package:campus_app/providers/notice_board_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screens/notice_board_screens/edit_notice_screen.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum Condition { Edit, Create }
enum PopUpOptions { Edit, Delete }

class NoticeBoardScreen extends StatefulWidget {
  static const routeName = '/notice_board_screen';

  @override
  _NoticeBoardScreenState createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  bool _isLoading = false;
  bool showMyNotices = false;
  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(
        Provider.of<NoticeBoardProvider>(context, listen: false).noticeList().then((_) {
          setState(() {
            _isLoading = false;
          });
        }),
        context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var noticeBoardProvider = Provider.of<NoticeBoardProvider>(context);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                AppBar().preferredSize.height + 20,
              ),
              child: CampusAppBar(
                title: "Notice board",
              ),
            ),
            body: Stack(
              children: [
                noticeBoardProvider.noticeBoardList.length==0?Center(child: Text("No posts were found"),):CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Show only my posts"),
                            Switch(
                              value: showMyNotices,
                              onChanged: (value) {
                                setState(() {
                                  showMyNotices = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    !showMyNotices
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () => showNoticeDetails(
                                          noticeBoardProvider.noticeBoardList[index], noticeBoardProvider, context),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        child: ClipOval(
                                          child: FadeInImage(
                                            placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                                            fit: BoxFit.cover,
                                            image: NetworkImage(noticeBoardProvider.noticeBoardList[index].imageUrl),
                                            imageErrorBuilder: (context, error, stackTrace) =>
                                                Image.asset(ConstAssetsPath.img_placeholderImage),
                                          ),
                                        ),
                                      ),
                                      title: Text(noticeBoardProvider.noticeBoardList[index].title),
                                      subtitle: Text(
                                        noticeBoardProvider.noticeBoardList[index].description,
                                        maxLines: 3,
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                );
                              },
                              childCount: noticeBoardProvider.noticeBoardList.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () => showNoticeDetails(
                                          noticeBoardProvider.myNoticeBoardList[index], noticeBoardProvider, context),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        child: ClipOval(
                                          child: FadeInImage(
                                            placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                                            fit: BoxFit.cover,
                                            image: NetworkImage(noticeBoardProvider.myNoticeBoardList[index].imageUrl),
                                            imageErrorBuilder: (context, error, stackTrace) =>
                                                Image.asset(ConstAssetsPath.img_placeholderImage),
                                          ),
                                        ),
                                      ),
                                      title: Text(noticeBoardProvider.myNoticeBoardList[index].title),
                                      subtitle: Text(
                                        noticeBoardProvider.myNoticeBoardList[index].description,
                                        maxLines: 3,
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                );
                              },
                              childCount: noticeBoardProvider.myNoticeBoardList.length,
                            ),
                          ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditNoticeScreen(),
                            ));
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  void showNoticeDetails(Notice notice, NoticeBoardProvider noticeBoardProvider, BuildContext context) {
    print(notice);
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                        fit: BoxFit.cover,
                        image: NetworkImage(notice.imageUrl),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(ConstAssetsPath.img_placeholderImage),
                      ),
                    ),
                  ),
                  title: Text(notice.title),
                  subtitle: Text(notice.createdAt ?? ""),
                  trailing: noticeBoardProvider.authData.login.userID == notice.creatorUserID
                      ? PopupMenuButton(
                          itemBuilder: (context) {
                            return List.generate(
                              PopUpOptions.values.length,
                              (popupindex) {
                                return PopupMenuItem(
                                  value: PopUpOptions.values[popupindex].index,
                                  child: Text(describeEnum(PopUpOptions.values[popupindex])),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.more_vert_sharp),
                          onSelected: (value) {
                            if (value == PopUpOptions.Edit.index) {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => EditNoticeScreen(existingNotice: notice)));
                            }
                            if (value == PopUpOptions.Delete.index) {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (_) => new AlertDialog(
                                  title: new Text(AppLocalizations.of(context).translate(str_simpleWarning)),
                                  content: new Text("Are you sure you want to delete a post"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_cancel)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(AppLocalizations.of(context).translate(str_confirm)),
                                      onPressed: () async {
                                        await CommonController.mutationFuture(
                                            noticeBoardProvider.deleteNotice(notice.noticeID).then((_) {
                                              Navigator.pop(context);
                                            }),
                                            AppLocalizations.of(context).translate(str_eventDeletedSuccess),
                                            context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      : null,
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                ListTile(
                  title: Text("Name"),
                  subtitle: Text(notice.creatorName + " " + notice.creatorSurname),
                  trailing: IconButton(icon: Icon(Icons.account_circle_sharp)),
                ),
                ListTile(
                  title: Text("Phone number"),
                  subtitle: Text(notice.phone),
                  trailing: IconButton(
                    onPressed: () {
                      if (notice.phone != "nonumber") {
                        launch("tel://${notice.phone}");
                      }
                    },
                    icon: Icon(
                      Icons.call,
                      color: Color(0xFF26B242),
                    ),
                  ),
                ),
                ListTile(
                    title: Text("Email"),
                    subtitle: Text(notice.email),
                    trailing: IconButton(
                      onPressed: () async {
                        await noticeBoardProvider.sendTranscriptRequest(notice.email, notice.title);
                      },
                      icon: Icon(
                        Icons.email,
                        color: Color(0xFF40BDD6),
                      ),
                    )),
                Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                  child: Text("Description",style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(notice.description,textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
