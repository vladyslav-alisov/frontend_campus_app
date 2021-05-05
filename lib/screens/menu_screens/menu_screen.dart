import 'package:campus_app/models/AuthData.dart';
import 'package:campus_app/models/menu/Menu.dart';
import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/providers/user_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/menu_screens_controllers/menu_screen_controller.dart';
import 'package:campus_app/screens/menu_screens/menu_edit_screen.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum Meals { redMeal, whiteMeal, vegMeal, soup, salad, dessert }
enum UserType {
  Cook
}

class MenuScreen extends StatelessWidget {
  static const String routeName = "/menu_screen";
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuScreenController(),
      child: MenuScreenScaffold(),
    );
  }
}

class MenuScreenScaffold extends StatefulWidget {
  @override
  _MenuScreenScaffoldState createState() => _MenuScreenScaffoldState();
}

class _MenuScreenScaffoldState extends State<MenuScreenScaffold> {
  bool _isLoading = false;
  @override
  void initState() {
    _isLoading = true;
    CommonController.queryFuture(Provider.of<MenuProvider>(context, listen: false).menu(), context).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userType = Provider.of<AuthProvider>(context).authData.login.typeOfUser;
    var menuProvider = Provider.of<MenuProvider>(context);
    var devSize = MediaQuery.of(context).size;

    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                AppBar().preferredSize.height + 20,
              ),
              child: CapmusAppBar(
                actionWidget: userType == describeEnum(UserType.Cook)?IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.pushNamed(context, MenuEditScreen.routeName),
                ): Container(),
                title: MyConstants.funcTitles[7],
              ),
            ),
            body: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 2,),
              itemCount: menuProvider.menuList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(describeEnum(Days.values[index]),style: Theme.of(context).textTheme.headline3,),
                    ),
                    Container(
                      height: devSize.height * 0.2,
                      child: ListView(

                        children: [
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].soup,
                          ),
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].whiteMeal,
                          ),
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].whiteMeal,
                          ),
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].vegMeal,
                          ),
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].salad,
                          ),
                          ContainerFood(
                            devSize: devSize,
                            meal: menuProvider.menuList[index].dessert,
                          ),
                        ],
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class ContainerFood extends StatelessWidget {
  const ContainerFood({
    Key key,
    @required this.devSize,
    @required this.meal,
  }) : super(key: key);

  final Size devSize;
  final meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0),
      child: Container(
        height: devSize.height * 0.3,
        width: devSize.width * 0.5,
        child: Column(
          children: [
            AspectRatio(aspectRatio: 2, child: Image.asset(ConstAssetsPath.img_defaultEvent,fit: BoxFit.cover,)),
            Text(meal ?? ""),
          ],
        ),
      ),
    );
  }
}
