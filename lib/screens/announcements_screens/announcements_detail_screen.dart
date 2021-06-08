import 'package:campus_app/models/Announcements.dart';
import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';

class AnnouncementsDetailScreen extends StatelessWidget {
  static const String routeName = "/announcements_screen";
  AnnouncementsDetailScreen(this.articles);
  final Articles articles;
  @override
  Widget build(BuildContext context) {
    return AnnouncementsDetailScaffold(articles);
  }
}

class AnnouncementsDetailScaffold extends StatefulWidget {
  AnnouncementsDetailScaffold(this.articles);
  final Articles articles;
  @override
  _AnnouncementsDetailScaffoldState createState() => _AnnouncementsDetailScaffoldState();
}

class _AnnouncementsDetailScaffoldState extends State<AnnouncementsDetailScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            AppBar().preferredSize.height + 20,
          ),
          child: CampusAppBar(
            title: widget.articles.title,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.articles.urlToImage == null
                              ? Image.asset(
                            ConstAssetsPath.img_placeholderImage,
                            fit: BoxFit.cover,
                          )
                              : NetworkImage(widget.articles.urlToImage),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                          onError: (exception, stackTrace) => Container(
                            child: Center(
                              child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          widget.articles.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(widget.articles.publishedAt.substring(0, 10),),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.articles.content,
                  maxLines: 100,
                ),
              ),
            ],
          ),
        ));
  }
}
