import 'package:campus_app/models/Announcements.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/material.dart';

class CampusAnnouncementsListTile extends StatelessWidget {
  CampusAnnouncementsListTile(this.article);
  final Articles article;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListTile(
        tileColor: Colors.white,
        title: article.urlToImage != null
            ? AspectRatio(
                aspectRatio: 2,
                child: GridTile(
                  footer: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: GridTileBar(
                      backgroundColor: Colors.black54,
                      title: Text(
                        article.title,
                        maxLines: 5,
                        style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          child: Center(
                            child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                          ),
                        );
                      },
                      placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                      image: NetworkImage(article.urlToImage),
                    ),
                  ),
                ),
              )
            : Image.asset(
                ConstAssetsPath.img_placeholderImage,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
