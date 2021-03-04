import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = "/profile_screen";

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Container(
            color: Theme.of(context).primaryColor,
            height: 10,
          ),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: MyConstants.appBarColors,
            ),
          ),
        ),
        title: Text(
          MyConstants.str_profile,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 14,
              bottom: 14,
              left: 14,
              right: 14,
            ),
            child: Container(
              height: devSize.height * 0.6,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                          image: DecorationImage(
                              image: NetworkImage('https://googleflutter.com/sample_image.jpg'), fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "Vladyslav Alisov" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 24),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "Computer Engineering" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "vladyslav.alisov@std.antalya.edu.tr" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "190201116" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "Antalya, Turkey" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "+905318338411" ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 25,
              left: 14,
              right: 14,
            ),
            child: Container(
              height: devSize.height * 0.3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 63,right: 40),
                  child: Row(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 58.0,),
                        child: Image(
                          height: 85,
                          width: 85,
                          image: AssetImage(MyConstants.assetPaths[2],),),
                      ),
                       Padding(
                         padding: const EdgeInsets.only(bottom: 79,left: 18),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                MyConstants.str_studentCardBalance ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 15),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                "TL: 20.25" ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
                              ),
                            ),
                          ],
                      ),
                       ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
