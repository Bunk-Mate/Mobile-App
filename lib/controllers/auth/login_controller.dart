import 'dart:convert';
import 'package:bunk_mate/controllers/homepage/course_summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class LoginController extends GetxController {
  final CourseSummaryController courseSummaryController = Get.put(CourseSummaryController());
  final _storage = const FlutterSecureStorage();
  var isLogged = false.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }
Future<bool> logoutfunction() async {
      var headers = { HttpHeaders.authorizationHeader: "Token ${await getToken()}"};
      try {
        var url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.logoutEmail);
        http.Response response =
            await http.post(url, headers: headers);
        if (response.statusCode == 200) {
          await _storage.delete(key: 'token');
          isLogged.value = false;

        } else {
          throw jsonDecode(response.body);
        }
      } catch (error) {
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Error'),
                contentPadding: const EdgeInsets.all(20),
                children: [Text(error.toString())],
              );
            });
      }
    return isLogged.value;
    }
  Future<bool> loginFunction() async {
    var headers = {"Content-Type": "application/json"};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);
      String body = jsonEncode({
        'username': usernameController.value.text,
        'password': passwordController.value.text
      });
      http.Response response =
          await http.post(url, body: body, headers: headers);
      if (response.statusCode == 202) {
        final json = jsonDecode(response.body);
        var token = json['token'];
        usernameController.clear();
        passwordController.clear();
        await _storage.write(key: 'token', value: token);
        isLogged.value = true;
      } else {
        isLogged.value = false;
        throw jsonDecode(response.body) ?? 'Unknown Error occured';
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  return isLogged.value ;
}
}