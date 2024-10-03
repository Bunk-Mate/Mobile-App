import 'dart:convert';
import 'dart:io';
import 'package:bunk_mate/models/time_table_model.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';


class TimeTableController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  var courses = <Course>[].obs;
  var schedule = <Schedule>[].obs;
  static const String apiUrl = ApiEndPoints.baseUrl;

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}courses'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        courses.value = jsonResponse.map((course) => Course.fromJson(course)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
     
    }
  }

  Future<void> getSchedule() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}schedules'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        List<Schedule> tempSchedule = [];

        jsonResponse.forEach((day, courses) {
          tempSchedule.add(Schedule.fromJson(day, courses));
        });

        schedule.value = tempSchedule;
      } else {
        _handleError(response);
      }
    } catch (e) {
    }
  }

  Future<void> addSchedule(String url, int day) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: jsonEncode({"day_of_week": day}),
      );

      if (response.statusCode == 201) {
        await getSchedule();
        Get.snackbar("Success", "Schedule has been added!");
      } else {
        _handleError(response);
      }
    } catch (e) {
    }
  }

  Future<void> addCourse(String courseName, int day) async {
    if (courseName.isEmpty) {
      return;
    }

    
    try {
      final response = await http.post(
        Uri.parse("${apiUrl}courses"),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: jsonEncode({
          "name": courseName,
          "schedules": {"day_of_week": day},
        }),
      );
      print(getToken());
      print(day);
      print(courseName);
    debugPrint(response.body);
      if (response.statusCode == 201) {
        await getSchedule();
        Get.snackbar("Success", "Course has been added!");
      } else {
        _handleError(response);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to add course: $e");
    }
  }

  void _handleError(http.Response response) {
    String message;
    try {
      final responseBody = jsonDecode(response.body);
      message = responseBody['detail'] ?? 'Unknown error occurred';
    } catch (e) {
      message = 'Failed to parse error response';
    }
  }
}
