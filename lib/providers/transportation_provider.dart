import 'dart:developer';

import 'package:campus_app/widgets/transportation_widgets/CampusTransportationListTile.dart';
import 'package:flutter/cupertino.dart';

class TransportationProvider with ChangeNotifier{

  List<Service> serviceList = [];
  Future<void> getServiceList(){
    serviceList = [];
    serviceList.addAll(
      [
        Service(name: "S1",time: "12.30 - 15:00 - 18:40",routes: "Döşemealtı - Kepez - Kültür - Otogar - 5M Migros - Türkay Hotel - Uncalı - Uncalı Mezarlığı",startEnd: "UNIVERSITY - KONYAALTI"),
        Service(name: "S2",time: "12.30 - 15:00 - 18:40",routes: "Döşemealtı - Kepez - Kültür - Otogar - 5M Migros - Türkay Hotel - Uncalı - Uncalı Mezarlığı",startEnd: "UNIVERSITY - Lara"),
        Service(name: "S3",time: "12.30 - 15:00 - 18:40",routes: "Döşemealtı - Kepez - Kültür - Otogar - 5M Migros - Türkay Hotel - Uncalı - Uncalı Mezarlığı",startEnd: "UNIVERSITY - DEDEMAN"),
        Service(name: "S4",time: "12.30 - 15:00 - 18:40",routes: "Döşemealtı - Kepez - Kültür - Otogar - 5M Migros - Türkay Hotel - Uncalı - Uncalı Mezarlığı",startEnd: "UNIVERSITY - MURATPASA"),

      ]
    );
  }
}