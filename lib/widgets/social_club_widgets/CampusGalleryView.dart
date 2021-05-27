import 'package:campus_app/models/social_clubs/GalleryList.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.initialIndex = 0,
    this.galleryItems,
  }) : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final PageController pageController;
  final List<Gallery> galleryItems;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (context, index) => PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.galleryItems[index].imageUrl),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
                      maxScale: PhotoViewComputedScale.covered * 4.1,
                    ),
                itemCount: widget.galleryItems.length,
                pageController: widget.pageController,
                onPageChanged: onPageChanged,
                scrollDirection: Axis.horizontal),
            Align(
                alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  widget.galleryItems[currentIndex].description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    decoration: null,
                  ),
                ),
              ),
            ),
            Align(alignment: Alignment.topRight,child: IconButton(icon: Icon(Icons.clear,color: Colors.white,),onPressed: () =>  Navigator.pop(context),)),
          ],
        ),
      ),
    );
  }
}
