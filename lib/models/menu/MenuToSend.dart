class MenuToSend {
  String dayID;
  String day;
  String redMeal;
  String whiteMeal;
  String vegMeal;
  String soup;
  String salad;
  String dessert;

  MenuToSend({
    this.dayID,
    this.redMeal ="",
    this.whiteMeal ="",
    this.vegMeal ="",
    this.soup ="",
    this.salad ="",
    this.dessert =""
  });

  MenuToSend.fromJson(Map<String, dynamic> json) {
    dayID= json['dayID'];
    redMeal= json['redMeal'];
    whiteMeal= json['whiteMeal'];
    vegMeal= json['vegMeal'];
    soup= json['soup'];
    salad= json['salad'];
    dessert= json['dessert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayID']=this.dayID;
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
    return '{ "dayID": ${this.dayID},"redMeal": ${this.redMeal},"whiteMeal": ${this.whiteMeal},"vegMeal": ${this.vegMeal},"soup": ${this.soup},"salad": ${this.salad},"dessert": ${this.dessert}}';
  }
}