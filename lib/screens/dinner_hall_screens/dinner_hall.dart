import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/dinner_hall_screen_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_edit_screen.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum Meals { soup, redMeal, whiteMeal, vegMeal, salad, dessert }
enum UserType { Cook }

class DinnerHallScreen extends StatefulWidget {
  static const String routeName = "/menu_screen";

  @override
  _DinnerHallScreenState createState() => _DinnerHallScreenState();
}

class _DinnerHallScreenState extends State<DinnerHallScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<MenuProvider>(context, listen: false).menu(), context).then((_) {
     if(this.mounted){ setState(() {
        _isLoading = false;
      });}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userType = Provider.of<AuthProvider>(context).authData.login.typeOfUser;
    var menuProvider = Provider.of<MenuProvider>(context);
    var devSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            AppBar().preferredSize.height + 20,
          ),
          child: CampusAppBar(
            actionWidget: userType == describeEnum(UserType.Cook)
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Provider.of<MenuEditScreenController>(context, listen: false)
                          .initVariables(menuProvider.menuList);
                      Navigator.pushNamed(context, MenuEditScreen.routeName);
                    },
                  )
                : Container(),
            title: AppLocalizations.of(context).translate(str_dinnerHall),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                separatorBuilder: (context, dayIndex) => Divider(
                  height: 2,
                ),
                itemCount: menuProvider.menuList.length,
                itemBuilder: (context, dayIndex) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context).translate(describeEnum(Days.values[dayIndex])),
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      Container(
                        height: devSize.height * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: Meals.values.length,
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: AspectRatio(
                                aspectRatio: 1.3,
                                child: GridTile(
                                  footer: GridTileBar(
                                    backgroundColor: Colors.black54,
                                    title: Text(
                                      menuProvider.menuList[dayIndex].meals[index].mealName,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white,fontSize: 13),
                                    ),
                                  ),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(menuProvider.menuList[dayIndex].meals[index].mealImageUrl),
                                    placeholder: AssetImage(ConstAssetsPath.img_placeholderImage),
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      print(error);
                                      print(stackTrace);
                                      return Container(
                                        child: Center(
                                          child: FittedBox(
                                            child: Text("Something went wrong"),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class ContainerFood extends StatefulWidget {
  const ContainerFood({Key key, @required this.devSize, @required this.mealName, @required this.mealImage})
      : super(key: key);

  final Size devSize;
  final String mealName;
  final String mealImage;

  @override
  _ContainerFoodState createState() => _ContainerFoodState();
}

class _ContainerFoodState extends State<ContainerFood> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        height: widget.devSize.height * 0.3,
        width: widget.devSize.width * 0.5,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.mealImage == null
                        ? AssetImage(
                            ConstAssetsPath.img_placeholderImage,
                            //fit: BoxFit.fill,
                          )
                        : NetworkImage(widget.mealImage),
                    onError: (exception, stackTrace) => Container(
                      child: Center(
                        child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(widget.mealName ?? ""),
          ],
        ),
      ),
    );
  }
}
