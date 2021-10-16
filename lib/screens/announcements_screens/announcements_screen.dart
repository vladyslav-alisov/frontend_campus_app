import 'package:campus_app/providers/announcements_provider.dart';
import 'package:campus_app/screens/announcements_screens/announcements_detail_screen.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/announcements_widgets/CampusAnnouncementsListTile.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AnnouncementsScreen extends StatefulWidget {
  static const String routeName = "/announcements_screen";

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {

  bool isLoading = false;
  @override
  void initState() {
    isLoading = true;
    Provider.of<AnnouncementsProvider>(context, listen: false).getAnnouncements().then((_) {
      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var announcements = Provider.of<AnnouncementsProvider>(context).announcements;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_announcements),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnnouncementsDetailScreen(announcements[index]))),
                  child: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: announcements[index].urlToImage == null
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnnouncementsDetailScreen(announcements[index]))),
                  ),
                ),
                childCount: announcements.length),
          ),
        ],
      ),
    );
  }
}

