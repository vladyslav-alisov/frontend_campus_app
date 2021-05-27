class MealOptions {
  String sTypename;
  List<Meals> meals;

  MealOptions({this.sTypename, this.meals});

  MealOptions.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    if (json['meals'] != null) {
      meals = new List<Meals>();
      json['meals'].forEach((v) {
        meals.add(new Meals.fromJson(v));
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

  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"meals": ${this.meals}}';
  }
}

class Meals {
  String sTypename;
  String mealID;
  String mealType;
  String mealName;
  String mealImageUrl;

  Meals(
      {this.sTypename,
        this.mealID,
        this.mealType,
        this.mealName,
        this.mealImageUrl});

  Meals.fromJson(Map<String, dynamic> json) {
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


  @override
  String toString() {
    return '{"sTypename": ${this.sTypename},"mealID": ${this.mealID},"mealType": ${this.mealType},"mealName": ${this.mealName},"mealImageUrl": ${this.mealImageUrl}}';
  }
}