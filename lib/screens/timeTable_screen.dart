import 'package:campus_app/providers/timetable_provider.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusTimeTableCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//todo add share button to appbar to send your courses schedule
class TimeTable extends StatefulWidget {
  static const String routeName = "/timeTable_screen";

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  bool _isLoading = false;

  int today() {
    var today = DateTime.now().weekday;
    if (today == 6 || today == 7) {
      today = 1;
    }
    return today;
  }

  @override
  void initState() {
    _isLoading = true;
    Provider.of<TimeTableProvider>(context,listen: false).timetable().then((_) {
      setState(() {
        _isLoading=false;
      });
    }).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          action: SnackBarAction(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            label: AppLocalizations.of(context).translate(str_hideMessage),
            textColor: Colors.white,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          content: Text(e),
        ),
      );
    });
    super.initState();
  }

  Future<void> _refreshCourses(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<TimeTableProvider>(context, listen: false)
        .timetable()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget build(BuildContext context) {
    var timeTable = Provider.of<TimeTableProvider>(context, listen: false);
    return DefaultTabController(
      initialIndex: today() - 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.headline1,
            isScrollable: true,
            labelPadding: EdgeInsets.all(15),
            automaticIndicatorColorAdjustment: true,
            tabs: MyConstants.days,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: MyConstants.appBarColors,
              ),
            ),
          ),
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
                    child: TimeTableCards(
                      courses: timeTable.mondayCourses,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () => _refreshCourses(context),
                    child: TimeTableCards(
                      courses: timeTable.tuesdayCourses,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () => _refreshCourses(context),
                    child: TimeTableCards(
                      courses: timeTable.wednesdayCourses,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () => _refreshCourses(context),
                    child: TimeTableCards(
                      courses: timeTable.thursdayCourses,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: () => _refreshCourses(context),
                    child: TimeTableCards(
                      courses: timeTable.fridayCourses,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
