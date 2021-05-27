/*
import 'package:campus_app/models/socialClub.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

class CampusSocialClubListTile extends StatelessWidget {
  CampusSocialClubListTile(this._socialClub);
  final SocialClub _socialClub;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                child: _socialClub.imageUrl.contains("cloudinary")
                    ? FadeInImage(
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      child: Center(
                        child: Text(str_errorLoadImage),
                      ),
                    );
                  },
                  placeholder: AssetImage(ConstAssetsPath.img_placeHolder),
                  image: NetworkImage(_event.imageUrl),
                )
                    : Image.asset(
                  ConstAssetsPath.img_placeHolder,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: ListTile(
              title: Text(
                _socialClub.date,
                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 17),
              ),
              subtitle: Text(
                _socialClub.,
                style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12, color: Color(0xff363636)),
              ),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
*/
