import 'dart:convert';
import 'package:bunk_mate/models/course_summary_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:io';

class CourseSummaryController extends GetxController {
  var courseSummary = <CourseSummary>[].obs;
  final storage = const FlutterSecureStorage();

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
      response = http.Response(response.body, 200);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        var fetchedSummary =
            jsonData.map((data) => CourseSummary.fromJson(data)).toList();

        courseSummary.assignAll(fetchedSummary);
        print("Task Done");
        print(response.body);
      } else {
        var errorResponse = jsonDecode(response.body);
        print(response.statusCode);
        throw errorResponse['detail'] ?? 'Unknown error occurred';
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }
}
