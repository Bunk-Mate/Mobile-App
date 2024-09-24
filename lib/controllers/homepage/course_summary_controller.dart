import 'dart:convert';
import 'package:bunk_mate/models/course_summary_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:io';
import 'package:bunk_mate/screens/OnBoardView.dart';

class CourseSummaryController extends GetxController {
  var courseSummary = <CourseSummary>[].obs;
  final storage = const FlutterSecureStorage();

  var checkIn = false.obs;
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> fetchCourseSummary() async {
    final token = await getToken();
    if (token == null) {
      Get.snackbar('Error', 'No token found.');
      return;
    }
    var headers = {
      HttpHeaders.authorizationHeader: "Token $token",
    };

    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.homeEndPoints.courseSummary);
      http.Response response = await http.get(url, headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, String> responseMap = json.decode(response.body);
        print(responseMap);
          checkIn.value = true;
          List<dynamic> jsonData = json.decode(response.body);
          var fetchedSummary =
              jsonData.map((data) => CourseSummary.fromJson(data)).toList();
          print(response.body);
          print(jsonData[0]);

          courseSummary.assignAll(fetchedSummary);
          print("Task Done");
        }
      else {
        Get.off(TimetableView());
      }
    } catch (error) {
      print(error);
    }
  }
}
