import 'package:campus_app/providers/transportation_provider.dart';
import 'package:campus_app/screen_controllers/event_screens_controllers/event_edit_screen_controller.dart';
import 'package:campus_app/screens/transportation_screens/transportation_detail_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/transportation_widgets/CampusTransportationListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransportationScreen extends StatelessWidget {
  static const String routeName = "/transportation_screen";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventEditScreenController(),
      child: TransportationScreenScaffold(),
    );
  }
}

class TransportationScreenScaffold extends StatefulWidget {
  @override
  _TransportationScreenScaffoldState createState() => _TransportationScreenScaffoldState();
}

class _TransportationScreenScaffoldState extends State<TransportationScreenScaffold> {
  bool _isLoading = true;
  @override
  void initState() {
    //todo: add api for service's data
    _isLoading = true;
    /* CommonController.queryFuture(Provider.of<TransportationProvider>(context,listen: false).getServiceList(), context).then((_){
      setState(() {
        _isLoading = false;
      });
    });*/
    Provider.of<TransportationProvider>(context, listen: false).getServiceList();
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    var transportationProvider = Provider.of<TransportationProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(
        AppBar().preferredSize.height + 10,
      ),
      child: CampusAppBar(
        title: AppLocalizations.of(context).translate(str_transportation),
      ),
    ),
      body: _isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : CampusTransportationListTile(transportationProvider.serviceList),
    );
  }
}
