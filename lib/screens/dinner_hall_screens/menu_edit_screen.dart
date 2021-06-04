import 'package:campus_app/models/menu/Food.dart';
import 'package:campus_app/providers/menu_provider.dart';
import 'package:campus_app/screen_controllers/common_controller.dart';
import 'package:campus_app/screen_controllers/dinner_hall_screen_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/screens/dinner_hall_screens/meal_select_screen.dart';
import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Days { Monday, Tuesday, Wednesday, Thursday, Friday }
enum MealTitles { Soup, Red_Meat_Meal, White_Meat_Meal, Vegetable_Meal, Salad, Dessert }
enum Meals { soup, redMeal, whiteMeal, vegMeal, salad, dessert }

class MenuEditScreen extends StatefulWidget {
  static const String routeName = "/menu_edit_screen";

  @override
  _MenuEditScreenState createState() => _MenuEditScreenState();
}

class _MenuEditScreenState extends State<MenuEditScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  TabController tabController;

  @override
  void initState() {
    _isLoading = true;
    var screenController = Provider.of<MenuEditScreenController>(context, listen: false);
    var menu = Provider.of<MenuProvider>(context, listen: false).menuList;
    CommonController.queryFuture(Provider.of<MenuProvider>(context, listen: false).meals(), context).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: screenController.chosenDay);
  }

  @override
  Widget build(BuildContext context) {
    var menuProvider = Provider.of<MenuProvider>(context);
    var screenController = Provider.of<MenuEditScreenController>(context);
    return WillPopScope(
            onWillPop: () async {
              if (screenController.listsEqual(menuProvider.menuList)) {
                return true;
              } else {
                return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    title: Text("Change Day?"),
                    content: Text("All unsaved changes will be canceled."),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          "Stay",
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Leave",
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  screenController.listsEqual(menuProvider.menuList)
                      ? Container()
                      : IconButton(
                    onPressed: () => CommonController.mutationFuture(menuProvider.chooseMeals(screenController.tempMenuList, tabController.index),"Menu successfully updated",context),
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        ),
                ],
                centerTitle: false,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).primaryColor,
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: TabBar(
                            controller: tabController,
                            onTap: (value) {
                              if (!screenController.listsEqual(menuProvider.menuList)) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    title: Text("Change Day?"),
                                    content: Text("All unsaved changes will be canceled."),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            print(tabController.index);
                                            tabController.index = tabController.previousIndex;
                                          });
                                        },
                                        child: Text(
                                          "Stay",
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          screenController.copyList(menuProvider.menuList);
                                        },
                                        child: Text(
                                          "Change Day",
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            labelStyle: Theme.of(context).textTheme.headline1,
                            isScrollable: true,
                            labelPadding: EdgeInsets.all(15),
                            automaticIndicatorColorAdjustment: true,
                            tabs: List.generate(
                                Days.values.length,
                                (index) => Text(describeEnum(Days.values[index]),
                                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey)))),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: MyConstants.appBarColors,
                    ),
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context).translate(str_menu),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              body: _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )

                  : TabBarView(
                  controller: tabController,
                  children: List.generate(
                    tabController.length,
                    (dayIndex) => ListView.builder(
                      itemCount: Meals.values.length,
                      itemBuilder: (BuildContext context, int mealIndex) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealSelectScreen(
                                menuProvider.mealOptions[mealIndex].meals,
                                describeEnum(MealTitles.values[mealIndex]).replaceAll("_", " "),
                                mealIndex,
                                tabController.index,
                              ),
                            ),
                          ),
                          child: ListTileMeal(
                            meal: screenController.tempMenuList[tabController.index].meals[mealIndex],
                            mealTitle: describeEnum(MealTitles.values[mealIndex]),
                          ),
                        );
                      },
                    ),
                  )),
            ),
          );
  }
}

class ListTileMeal extends StatelessWidget {
  const ListTileMeal({
    Key key,
    @required this.meal,
    @required this.mealTitle,
    @required this.callBack,
  }) : super(key: key);

  final Meal meal;
  final String mealTitle;
  final Future callBack;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Container(
        child: AspectRatio(
          aspectRatio: 1.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              image: NetworkImage(meal.mealImageUrl),
              placeholder: AssetImage(ConstAssetsPath.img_placeHolder),
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
      title: Text(mealTitle.replaceAll("_", " ")),
      subtitle: Text(meal.mealName),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward_ios_outlined),
        onPressed: () => callBack,
      ),
    );
  }
}
