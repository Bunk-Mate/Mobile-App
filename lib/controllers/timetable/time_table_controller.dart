import 'dart:convert';
import 'dart:io';
import 'package:bunk_mate/models/time_table_model.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class TimeTableController extends GetxController {
  final storage = FlutterSecureStorage();
  var courses = <Course>[].obs;
  var schedule = <Schedule>[].obs;
  static const apiUrl = ApiEndPoints.baseUrl;

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> getCourses() async {
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
      throw Exception('Failed to retrieve courses');
    }
  }

Future<void> getSchedule() async {
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
    throw Exception('Failed to retrieve schedule');
  }
}


  Future<void> addSchedule(String url, int day) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"day_of_week": day}),
    );
    print(response.body);
    if (response.statusCode == 201) {
      await getSchedule();
      // Get.snackbar("Success", "Schedule has been added for existing course!");
    } else {
      // Get.snackbar("Error", "Failed to add Schedule");
      throw Exception('Failed to add schedule');
    }
  }

  Future<void> addCourse(String courseName, int day) async {
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
    print(response.body);
    if (response.statusCode == 201) {
      await getSchedule();
      Get.snackbar("Success", "Course has been added!");
    } else {
      Get.snackbar("Error", "Failed to add course!");
      throw Exception('Failed to add course!');
    }
  }
}
