import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CardFunction.dart';
import 'package:campus_app/widgets/CustomClipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatelessWidget {
  static const routeName = "/home_screen";

  @override
  Widget build(BuildContext context) {

    final devSize = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      height: devSize.height,
      width: devSize.width,
      child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  width: devSize.width,
                  color: Theme.of(context).primaryColor,
                  height: devSize.height * 0.315,
                ),
              ),
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: devSize.height * 0.30,
                  width: devSize.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: MyConstants.appBarColors,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: devSize.height * 0.685,
            width: devSize.width,
            child: GridView.builder(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 17.0,
              ),
              itemCount: MyConstants.funcTitles.length,
              itemBuilder: (context, index) => cardFunction(
                context: context,
                imagePath: MyConstants.assetPaths[index],
                label: MyConstants.funcTitles[index],
                color: MyConstants.funcColors[index],
                path: MyConstants.routes[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}
