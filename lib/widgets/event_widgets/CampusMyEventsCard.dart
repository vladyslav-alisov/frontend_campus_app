import 'package:campus_app/models/events/EventList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';


class CampusMyEventCard extends StatelessWidget {
  const CampusMyEventCard({
    @required this.index,
    @required this.eventList,
    @required this.functionButtonOne,
    @required this.functionButtonTwo,
    @required this.iconButtonOne,
    @required this.iconButtonTwo,
    @required this.titleButtonOne,
    @required this.titleButtonTwo,
  });

  final int index;
  final List<Event> eventList;
  final Function functionButtonOne;
  final Function functionButtonTwo;
  final Icon iconButtonOne;
  final Icon iconButtonTwo;
  final String titleButtonOne;
  final String titleButtonTwo;
  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: eventList[index].imageUrl.contains("cloudinary")
                          ? Card(
                        child: FadeInImage(
                          fit: BoxFit.fill,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              child: Center(
                                child: Text("Could not load an image"),
                              ),
                            );
                          },
                          placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                          image: NetworkImage(eventList[index].imageUrl),
                        ),
                      )
                          : Image.asset(
                        ConstAssetsPath.img_placeholderImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(eventList[index].date),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            eventList[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(eventList[index].location),
                          SizedBox(
                            height: 5,
                          ),
                          Text(eventList[index].time),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        FittedBox(
                          child: OutlinedButton.icon(
                            icon: iconButtonOne,
                            label: Text(
                              AppLocalizations.of(context).translate(titleButtonOne),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            onPressed: () => functionButtonOne(),
                          ),
                        ),
                        FittedBox(
                          child: OutlinedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            onPressed: () => functionButtonTwo(),
                            icon: iconButtonTwo,
                            label: Text(
                              AppLocalizations.of(context).translate(titleButtonTwo),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

}
}