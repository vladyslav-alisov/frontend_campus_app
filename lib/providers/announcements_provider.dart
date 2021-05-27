import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AnnouncementsProvider with ChangeNotifier {
  Future<void> getAnnouncements() async {
    await http.get(Uri.https("mma-ufc-news.p.rapidapi.com", "/latest"), headers: {
      "x-rapidapi-key": "87a1aa3a31msh94721fd974460dap1f81fajsn7393ad565d7c",
      "x-rapidapi-host": "mma-ufc-news.p.rapidapi.com",
      "useQueryString": "true"
    }).then(
      (value) async {
        if (value.body != null) {
          log("${value.body}");
        }
      },
    ).catchError((e) => print(e));
  }
}
