class MenuList {
  String sTypename;
  List<Menu> menu;

  MenuList({this.sTypename, this.menu});

  MenuList.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['menu'] != null) {
      menu = [];
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

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename}, "menu": ${this.menu}}';
  }

}

class Menu {
  String sTypename;
  String menuID;
  String dayID;
  String day;
  String redMeal;
  String whiteMeal;
  String vegMeal;
  String soup;
  String salad;
  String dessert;

  Menu({
        this.sTypename,
        this.menuID ="",
        this.dayID ="",
        this.day ="",
        this.redMeal ="",
        this.whiteMeal ="",
        this.vegMeal ="",
        this.soup ="",
        this.salad ="",
        this.dessert =""
});

  Menu.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    menuID= json['menuID'];
    dayID= json['dayID'];
    day= json['day'];
    redMeal= json['redMeal'];
    whiteMeal= json['whiteMeal'];
    vegMeal= json['vegMeal'];
    soup= json['soup'];
    salad= json['salad'];
    dessert= json['dessert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['menuID']=this.menuID;
    data['dayID']=this.dayID;
    data['day']=this.day;
    data['redMeal']=this.redMeal;
    data['whiteMeal']=this.whiteMeal;
    data['vegMeal']=this.vegMeal;
    data['soup']=this.soup;
    data['salad']=this.salad;
    data['dessert']=this.dessert;
    return data;
  }

  @override
  String toString() {
    return '{ "sTypename": ${this.sTypename},"menuID": ${this.menuID},"dayID": ${this.dayID},"day": ${this.day},"redMeal": ${this.redMeal},"whiteMeal": ${this.whiteMeal},"vegMeal": ${this.vegMeal},"soup": ${this.soup},"salad": ${this.salad},"dessert": ${this.dessert}}';
  }
}