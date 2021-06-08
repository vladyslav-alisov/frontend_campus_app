import 'dart:convert';
import 'dart:developer';

import 'package:campus_app/models/Announcements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AnnouncementsProvider with ChangeNotifier {
  final endPointUrl = "newsapi.org";
  final client = http.Client();
  List<Articles> announcements;

  Future<void> getAnnouncements() async {
    final queryParameters = {
      'sources': 'techcrunch',
      'apiKey': '46ba552cddd34927bd716d33fcfcce0b'
    };
    final uri = Uri.https(endPointUrl, '/v2/top-headlines',queryParameters);
    final response = await client.get(uri);
    announcements = News.fromJson(jsonDecode(response.body)).articles;
  }
}
