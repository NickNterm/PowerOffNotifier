import 'dart:convert';

import 'package:power_off_notifier/constants/variables.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Map>> apiGetAnnouncementFromDepartment(String department) async {
    var url = "$urlAddress/$department";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json; charset=utf-8'
      },
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return (data as List)
        .map((dynamic e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<Map?> apiGetLatestAnnouncementFromDepartment(
      String department, int id) async {
    var url = "$urlAddress/latest?department=$department&id=$id";
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json; charset=utf-8'
      },
    );
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data) {
      try {
        Map announcement = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList()
            .first;
        return announcement;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
