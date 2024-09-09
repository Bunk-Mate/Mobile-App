import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class StatusController extends GetxController {
  final storage = FlutterSecureStorage();
  final String apiUrl;

  StatusController({required this.apiUrl}) {
    getStatus();
  }

  var courses = [].obs;
  var isHoliday = false.obs;
  var selectedDate = DateTime.now().obs;
  var statusUpdate = false.obs;

  Map<int, String> days = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  Color c1 = Colors.white; // Initial color

  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    return token;
  }

  Future<void> getStatus({DateTime? date}) async {
    final now = DateTime.now();
    final today = date ?? now;

    try {
      final response = await http.get(
        Uri.parse(apiUrl +
            '/datequery?date=${DateFormat('yyyy-MM-dd').format(today)}'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        courses.value = jsonDecode(response.body);
        statusUpdate.value = false;
      } else {
        throw Exception('Failed to retrieve status');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to retrieve status');
    }
  }

  Future<void> updateStatus(String url, String status, {DateTime? date}) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({"status": status}),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );

      if (response.statusCode == 200) {
        await getStatus(date: date);
        // Get.snackbar(
        //   'Status Updated',a
        //   'Status updated successfully!',
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update status');
    }
  }

  Future<void> addHoliday(int dayOfWeek) async {
    try {
      isHoliday.value = true;

      final response = await http.post(
        Uri.parse("$apiUrl/schedule_selector"),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: jsonEncode({
          "day_of_week": dayOfWeek,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate.value)
        }),
      );

      if (response.statusCode == 201) {
        await getStatus(date: selectedDate.value);
      } else {
        throw Exception('Failed to add Holiday');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
        await getStatus(date: picked);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  IconData getRandomSubjectIcon() {
    var subjectIcons = [
      Icons.abc,
    ];
    var randomIndex = subjectIcons.length > 0 ? 0 : 0;
    return subjectIcons[randomIndex];
  }
}
