import 'dart:convert';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:core';


class SignupController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool status = false;
    Future<void> signUpFunction() async {
    var headers = {"Content-Type": "application/json"};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);
      String body = jsonEncode({
        'username': usernameController.value.text,
        'password': passwordController.value.text
      });
 
      http.Response response = await http.post(url, body: body,  headers: headers);
      if (response.statusCode == 201) {
        usernameController.clear();
        passwordController.clear();
        Get.off(const AuthScreen());
      }
      else {
        throw jsonDecode(response.body) ?? 'Unknown Error occured' ;
      }
    } catch (error) {
      Get.back();
      showDialog(context: Get.context!, builder: (context){
        return SimpleDialog(
          title: const Text('Error'),
          contentPadding: const EdgeInsets.all(20),
          children: [Text(error.toString())],
        );
      });
    }
  } 
 }
