class Menus {
  String sTypename;
  List<Menu> menus;

  Menus({this.sTypename, this.menus});

  Menus.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['menu'] != null) {
      menus = [];
      json['menu'].forEach((v) {
        menus.add(new Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    if (this.menus != null) {
      data['menu'] = this.menus.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "menu": ${this.menus}}';
  }

}


class Menu {
  String sTypename;
  String menuID;
  String dayID;
  String day;
  String redMeal;
  String redMealImageUrl;
  String whiteMeal;
  String whiteMealImageUrl;
  String vegMeal;
  String vegMealImageUrl;
  String soup;
  String soupImageUrl;
  String salad;
  String saladImageUrl;
  String dessert;
  String dessertImageUrl;

  Menu(
      {this.sTypename,
        this.menuID,
        this.dayID,
        this.day,
        this.redMeal,
        this.redMealImageUrl,
        this.whiteMeal,
        this.whiteMealImageUrl,
        this.vegMeal,
        this.vegMealImageUrl,
        this.soup,
        this.soupImageUrl,
        this.salad,
        this.saladImageUrl,
        this.dessert,
        this.dessertImageUrl});

  Menu.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    menuID = json['menuID'];
    dayID = json['dayID'];
    day = json['day'];
    redMeal = json['redMeal'];
    redMealImageUrl = json['redMealImageUrl'];
    whiteMeal = json['whiteMeal'];
    whiteMealImageUrl = json['whiteMealImageUrl'];
    vegMeal = json['vegMeal'];
    vegMealImageUrl = json['vegMealImageUrl'];
    soup = json['soup'];
    soupImageUrl = json['soupImageUrl'];
    salad = json['salad'];
    saladImageUrl = json['saladImageUrl'];
    dessert = json['dessert'];
    dessertImageUrl = json['dessertImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['menuID'] = this.menuID;
    data['dayID'] = this.dayID;
    data['day'] = this.day;
    data['redMeal'] = this.redMeal;
    data['redMealImageUrl'] = this.redMealImageUrl;
    data['whiteMeal'] = this.whiteMeal;
    data['whiteMealImageUrl'] = this.whiteMealImageUrl;
    data['vegMeal'] = this.vegMeal;
    data['vegMealImageUrl'] = this.vegMealImageUrl;
    data['soup'] = this.soup;
    data['soupImageUrl'] = this.soupImageUrl;
    data['salad'] = this.salad;
    data['saladImageUrl'] = this.saladImageUrl;
    data['dessert'] = this.dessert;
    data['dessertImageUrl'] = this.dessertImageUrl;
    return data;
  }
  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"menuID": ${this.menuID},"dayID": ${this.dayID},"day": ${this.day},"redMeal": ${this.redMeal},"redMealImageUrl": ${this.redMealImageUrl},"whiteMeal": ${this.whiteMeal},"whiteMealImageUrl": ${this.whiteMealImageUrl},"vegMeal": ${this.vegMeal},"vegMealImageUrl": ${this.vegMealImageUrl},"soup": ${this.soup},"soupImageUrl": ${this.soupImageUrl},"salad": ${this.salad},"saladImageUrl": ${this.saladImageUrl},"dessert": ${this.dessert},"dessertImageUrl": ${this.dessertImageUrl}}';
  }
}