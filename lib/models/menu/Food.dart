class Food {
  String sTypename;
  List<Menu> menu;

  Food({this.sTypename, this.menu});

  Food.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['menu'] != null) {
      menu = new List<Menu>();
      json['menu'].forEach((v) {
        menu.add(new Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class MealsList {
  String sTypename;
  List<Menu> menu;

  MealsList({this.sTypename, this.menu});

  MealsList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['mealsList'] != null) {
      menu = new List<Menu>();
      json['mealsList'].forEach((v) {
        menu.add(new Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.menu != null) {
      data['mealsList'] = this.menu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  String sTypename;
  List<Meal> meals;

  Menu({this.sTypename, this.meals});

  Menu.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['meals'] != null) {
      meals = new List<Meal>();
      json['meals'].forEach((v) {
        meals.add(new Meal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.meals != null) {
      data['meals'] = this.meals.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meal {
  String sTypename;
  String mealID;
  String mealType;
  String mealName;
  String mealImageUrl;

  Meal(
      {this.sTypename,
        this.mealID,
        this.mealType,
        this.mealName,
        this.mealImageUrl});

  Meal.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    mealID = json['mealID'];
    mealType = json['mealType'];
    mealName = json['mealName'];
    mealImageUrl = json['mealImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['mealID'] = this.mealID;
    data['mealType'] = this.mealType;
    data['mealName'] = this.mealName;
    data['mealImageUrl'] = this.mealImageUrl;
    return data;
  }
}