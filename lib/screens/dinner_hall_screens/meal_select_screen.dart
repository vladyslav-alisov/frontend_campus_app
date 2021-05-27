import 'package:campus_app/utils/Localization.dart';
import 'package:campus_app/utils/MyConstants.dart';
import 'package:campus_app/widgets/CampusAppBar.dart';
import 'package:flutter/material.dart';

class MealSelectScreen extends StatelessWidget {
  MealSelectScreen(this.meals, this.mealType);
  final List meals;
  final String mealType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppBar().preferredSize.height + 20,
        ),
        child: CampusAppBar(
          title: AppLocalizations.of(context).translate(str_select),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 2, crossAxisCount: 4),
        itemBuilder: (context, index) => Container(
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: meals[index].imageUrl == null
                      ? Image.asset(
                          ConstAssetsPath.img_placeHolder,
                          fit: BoxFit.fill,
                        )
                      : NetworkImage(meals[index].imageUrl),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
                  onError: (exception, stackTrace) => Container(
                    child: Center(
                      child: Text(AppLocalizations.of(context).translate(str_errorLoadImage)),
                    ),
                  ),
                ),
              ),
              child: Text(meals[index].mealName),
            ),
          ),
        ),
      ),
    );
  }
}
