import 'package:bunk_mate/models/on_board_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OnBoardService {
  final storage = const FlutterSecureStorage();
  final String apiUrl = "https://api.bunkmate.in";

  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    return token;
  }

  Future<void> submitTimetable(OnBoardModel timetable) async {
    final response = await http.post(
      Uri.parse("$apiUrl/collection"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({
        "name": timetable.name,
        "start_date": timetable.startDate,
        "end_date": timetable.endDate,
        "courses_data": [],
        "shared": timetable.isShared
      }),
    );
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception("Could not create timetable");
    }
  }

  Future<void> timeTablePresets(int copyId) async {
    final response = await http.post(
      Uri.parse("$apiUrl/collection_selector"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"copy_id": copyId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to update timetable');
    }
  }

  Future<List<dynamic>> getTimeTable() async {
    final response = await http.get(Uri.parse("$apiUrl/collections"), headers: {
      HttpHeaders.authorizationHeader: "Token ${await getToken()}",
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load timetable');
    }
  }
}
