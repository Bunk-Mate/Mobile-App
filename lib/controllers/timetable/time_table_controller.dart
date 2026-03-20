import 'dart:convert';
import 'dart:io';
import 'package:bunk_mate/models/time_table_model.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TimeTableController extends GetxController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  var courses = <Course>[].obs;
  var schedule = <Schedule>[].obs;
  final Rxn<TimetableCollection> timetableCollection =
      Rxn<TimetableCollection>();
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
        courses.value =
            jsonResponse.map((course) => Course.fromJson(course)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to retrieve courses: $e",
        colorText: Colors.white,
      );
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
      Get.snackbar(
        "Error",
        "Failed to retrieve schedule: $e",
        colorText: Colors.white,
      );
    }
  }

  Future<void> getCollection() async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}collection'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        timetableCollection.value = TimetableCollection.fromJson(jsonResponse);
      } else {
        _handleError(response);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to retrieve timetable: $e",
        colorText: Colors.white,
      );
    }
  }

  Future<bool> updateCollectionCoursesData(
      List<List<String>> coursesData) async {
    try {
      final current = timetableCollection.value;
      if (current == null) {
        Get.snackbar(
          "Error",
          "No timetable found to update.",
          colorText: Colors.white,
        );
        return false;
      }

      final response = await http.put(
        Uri.parse('${apiUrl}collection'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "name": current.name,
          "shared": current.shared,
          "start_date": current.startDate,
          "end_date": current.endDate,
          "threshold": current.threshold,
          "courses_data": coursesData,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        timetableCollection.value = TimetableCollection(
          name: current.name,
          shared: current.shared,
          startDate: current.startDate,
          endDate: current.endDate,
          threshold: current.threshold,
          coursesData: coursesData,
        );
        return true;
      }

      final patchResponse = await http.patch(
        Uri.parse('${apiUrl}collection'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "courses_data": coursesData,
        }),
      );

      if (patchResponse.statusCode == 200 || patchResponse.statusCode == 204) {
        timetableCollection.value = TimetableCollection(
          name: current.name,
          shared: current.shared,
          startDate: current.startDate,
          endDate: current.endDate,
          threshold: current.threshold,
          coursesData: coursesData,
        );
        return true;
      }

      _handleError(patchResponse);
      return false;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update timetable: $e",
        colorText: Colors.white,
      );
      return false;
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
