import 'package:campus_app/providers/social_club_provider.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:campus_app/widgets/CampusExpandedPanel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SocialClubScreen extends StatefulWidget {
  static const routeName = '/socialClub_screen';

  @override
  _SocialClubScreenState createState() => _SocialClubScreenState();
}


class _SocialClubScreenState extends State<SocialClubScreen> {
  bool isExpanded=false;

  void expand(int index, bool isExpanded,List list){
    setState(() {
      list[index].isExpanded = !list[index].isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {

    final socialClubs = Provider.of<SocialClubProvider>(context,listen: false).socialClubsList;
    final devSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          devSize.height * 0.1,
        ),
        child: CampusAppBar(
          title: MyConstants.funcTitles[6],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
              right: 14,
              left: 14,
              top: 21,
            ),
            child: CustomExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => expand(panelIndex, isExpanded,socialClubs),
              children: List.generate(
                socialClubs.length,
                (index) => ExpansionPanel(
                  backgroundColor: Theme.of(context).primaryColor,
                  headerBuilder: (context, isExpanded) => Center(
                    child: Text(
                      socialClubs[index].name,
                      style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 30),
                    ),
                  ),
                  body: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            socialClubs[index].description,
                            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(24),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                child: Text(
                                  AppLocalizations.of(context).translate(str_join),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  isExpanded: socialClubs[index].isExpanded,
                  canTapOnHeader: true,
                ),
              ),
            ),
          ),
      ),
    );
  }
}
