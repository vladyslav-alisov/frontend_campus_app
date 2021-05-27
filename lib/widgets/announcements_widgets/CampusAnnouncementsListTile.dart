import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

class CampusAnnouncementsListTile extends StatelessWidget {
  CampusAnnouncementsListTile(this.lst);
  final Event lst;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: lst.imageUrl.contains("cloudinary")
                ? Card(
              child: FadeInImage(
                fit: BoxFit.contain,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    child: Center(
                      child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                    ),
                  );
                },
                placeholder: AssetImage(ConstAssetsPath.img_placeHolder),
                image: NetworkImage(lst.imageUrl),
              ),
            )
                : Image.asset(
              ConstAssetsPath.img_placeHolder,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: ListTile(

                title: Text(
                  lst.title,
                  style: Theme.of(context).textTheme.bodyText2,overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: Text(lst.description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: Theme.of(context).textTheme.bodyText1)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(lst.date,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context).textTheme.bodyText1),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                isThreeLine: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
