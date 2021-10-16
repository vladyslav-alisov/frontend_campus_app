import 'package:campus_app/models/menu/Food.dart';
import 'package:campus_app/screen_controllers/dinner_hall_screen_controllers/menu_edit_screen_controller.dart';
import 'package:campus_app/utils/localization.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:campus_app/widgets/general_widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealSelectScreen extends StatelessWidget {
  MealSelectScreen(this.meals, this.mealName, this.mealIndex,this.dayIndex);
  final List<Meal> meals;
  final int mealIndex;
  final String mealName;
  final int dayIndex;
  @override
  Widget build(BuildContext context) {
    var screenController = Provider.of<MenuEditScreenController>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_select) + " " + mealName,
        ),
      ),
      body: GridView.builder(
        itemCount: meals.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 1.3, crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            screenController.updateTempMenuList(meals[index],mealIndex,dayIndex);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(
                    meals[index].mealName,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white),
                  ),
                ),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(meals[index].mealImageUrl),
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
            )
          ),
        ),
      ),
    );
  }
}
