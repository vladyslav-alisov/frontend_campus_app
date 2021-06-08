import 'package:campus_app/providers/announcements_provider.dart';
import 'package:campus_app/providers/event_provider.dart';
import 'package:campus_app/screens/announcements_screens/announcements_detail_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/announcements_widgets/CampusAnnouncementsListTile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnouncementsScreen extends StatelessWidget {
  static const String routeName = "/announcements_screen";
  @override
  Widget build(BuildContext context) {
    return AnnouncementsScaffold();
  }
}

class AnnouncementsScaffold extends StatefulWidget {
  @override
  _AnnouncementsScaffoldState createState() => _AnnouncementsScaffoldState();
}

class _AnnouncementsScaffoldState extends State<AnnouncementsScaffold> {
  bool isLoading = false;
  @override
  void initState() {
    isLoading = true;
    Provider.of<AnnouncementsProvider>(context, listen:false).getAnnouncements().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var announcements = Provider.of<AnnouncementsProvider>(context).announcements;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 10,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate(str_announcements),
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  centerTitle: false,
                  floating: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: MyConstants.appBarColors,
                    )),
                  ),
                ),
                SliverToBoxAdapter(
                  child: announcements.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(AppLocalizations.of(context).translate(str_noDataFound))),
                        )
                      : CarouselSlider.builder(
                          itemCount: announcements.length,
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AnnouncementsDetailScreen(announcements[index]))),
                              child: Container(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: announcements[index].urlToImage== null
                                              ? AssetImage(
                                                  ConstAssetsPath.img_placeholderImage,
                                               //   fit: BoxFit.fill,
                                                )
                                              : NetworkImage(announcements[index].urlToImage),
                                          fit: BoxFit.cover,
                                          colorFilter:
                                              ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                                          onError: (exception, stackTrace) => Container(
                                            child: Center(
                                              child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          announcements[index].title,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 22),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            aspectRatio: 2,
                            viewportFraction: 1,
                            autoPlay: true,
                            pauseAutoPlayOnTouch: true,
                          ),
                        ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: GestureDetector(
                              child: CampusAnnouncementsListTile(announcements[index]),
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AnnouncementsDetailScreen(announcements[index]))),
                            ),
                          ),
                      childCount: announcements.length),
                ),
              ],
            ),
          );
  }
}
