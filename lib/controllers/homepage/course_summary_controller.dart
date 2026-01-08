import 'dart:convert';
import 'package:bunk_mate/models/course_summary_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:io';
import 'package:bunk_mate/screens/on_board_view.dart';

class CourseSummaryController extends GetxController {
  var courseSummary = <CourseSummary>[].obs;
  var isLoading = true.obs;
  final storage = const FlutterSecureStorage();
  
  @override
  void onInit() {
    super.onInit();
    fetchCourseSummary();
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> fetchCourseSummary() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      
      if (token == null) {
        return;
      }
      
      var headers = {
        HttpHeaders.authorizationHeader: "Token $token",
      };

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.homeEndPoints.courseSummary);
      
      http.Response response = await http.get(url, headers: headers);

      if (kDebugMode) {
        print(response.statusCode);
      }
      
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        var fetchedSummary =
            jsonData.map((data) => CourseSummary.fromJson(data)).toList();
        if (kDebugMode) {
          print(response.body);
        }
        if (kDebugMode) {
          print(jsonData[0]);
        }

        courseSummary.assignAll(fetchedSummary);
        if (kDebugMode) {
          print("Task Done");
        }
      }
      else if (response.statusCode == 404) {
        Get.offAll(const OnBoardView());
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching course summary: $error');
      }
    } finally {
      isLoading.value = false;
    }
  }
}