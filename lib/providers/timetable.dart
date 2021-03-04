import 'package:flutter/material.dart';

class TimeTableProvider with ChangeNotifier{

  int today(){
    var today = DateTime.now().day;
    if(today == 6 || today == 7){
      today = 1;
    }
    return today;
  }
}