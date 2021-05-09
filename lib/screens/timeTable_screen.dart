import 'package:campus_app/providers/timetable_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusTimeTableCard.dart';
import 'package:campus_app/widgets/timetable_widgets/CampusTimeTableListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//todo add share button to appbar to send your courses schedule
class TimeTableScreen extends StatefulWidget {
  static const String routeName = "/timeTable_screen";

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<TimeTableProvider>(context, listen: false).timetable(), context).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<void> _refreshCourses(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<TimeTableProvider>(context, listen: false).timetable().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    var timeTable = Provider.of<TimeTableProvider>(context, listen: false);
    return DefaultTabController(
      initialIndex: CommonController.today() - 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    labelStyle: Theme.of(context).textTheme.headline1,
                    isScrollable: true,
                    labelPadding: EdgeInsets.all(15),
                    automaticIndicatorColorAdjustment: true,
                    tabs: MyConstants.days,
                  ),
                ),
              ],
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: MyConstants.appBarColors,
              ),
            ),
          ),

          /*  bottom: PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Container(
              color: Theme.of(context).primaryColor,
              height: 10,
            ),
          ),*/

          title: Text(
            MyConstants.funcTitles[3],
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: _isLoading
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : TabBarView(
                children: [
                  RefreshIndicator(
                      onRefresh: () => _refreshCourses(context),
                      child: CampusTimeTableListTile(
                        timeTable.mondayCourses,
                      )),
                  RefreshIndicator(
                      onRefresh: () => _refreshCourses(context),
                      child: CampusTimeTableListTile(
                        timeTable.tuesdayCourses,
                      )),
                  RefreshIndicator(
                      onRefresh: () => _refreshCourses(context),
                      child: CampusTimeTableListTile(
                        timeTable.wednesdayCourses,
                      )),
                  RefreshIndicator(
                      onRefresh: () => _refreshCourses(context),
                      child: CampusTimeTableListTile(
                        timeTable.thursdayCourses,
                      )),
                  RefreshIndicator(
                      onRefresh: () => _refreshCourses(context),
                      child: CampusTimeTableListTile(
                        timeTable.fridayCourses,
                      )),
                ],
              ),
      ),
    );
  }
}
