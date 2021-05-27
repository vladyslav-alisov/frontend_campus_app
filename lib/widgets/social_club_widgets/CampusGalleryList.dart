import 'package:campus_app/models/social_clubs/GalleryList.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/social_club_widgets/CampusGalleryView.dart';
import 'package:flutter/material.dart';

class CampusGalleryList extends StatelessWidget {
  const CampusGalleryList({
    Key key,
    @required this.galleryList,
  }) : super(key: key);

  final List<Gallery> galleryList;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: galleryList.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GalleryPhotoViewWrapper(
                  galleryItems: galleryList,
                  initialIndex: index,
                ),
              ),
            ),
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: galleryList[index].imageUrl == null
                      ? AssetImage(
                    ConstAssetsPath.img_placeHolder,
                    //   fit: BoxFit.fill,
                  )
                      : NetworkImage(
                      galleryList[index].imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => Container(
                    child: Center(
                      child: Text(
                          AppLocalizations.of(context).translate(str_errorLoadImage)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}