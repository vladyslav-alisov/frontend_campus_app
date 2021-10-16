import 'package:campus_app/providers/document_request_provider.dart';
import 'package:campus_app/providers/profile_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/document_request_screens_controllers/document_request_screen_controller.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/document_request_widgets/CampusRequestListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentRequestScreen extends StatelessWidget {
  static const routeName = "/document_request";
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DocumentRequestScreenController(),
      child: DocumentRequestScaffold(),
    );
  }
}

class DocumentRequestScaffold extends StatefulWidget {
  @override
  _DocumentRequestScaffoldState createState() => _DocumentRequestScaffoldState();
}

class _DocumentRequestScaffoldState extends State<DocumentRequestScaffold> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<ProfileProvider>(context, listen: false).profile(), context).then((_) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<DocumentRequestScreenController>(context);
    var documentRequestProvider = Provider.of<DocumentRequestProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_documentRequest),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context).translate(str_requestOptions),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                )),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CampusRequestListTile(
                            "TRANSCRIPT REQUEST",
                            "Send request to Students Affairs for transcript document",
                            ElevatedButton(
                              style: ButtonStyle(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: MaterialStateProperty.all(Color(0XFFA9AEAF))),
                              child: Text(AppLocalizations.of(context).translate(str_sendRequest)),
                              onPressed: () {
                                screenController.showPurposeDialog(
                                    context, documentRequestProvider.sendTranscriptRequest);
                              },
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
