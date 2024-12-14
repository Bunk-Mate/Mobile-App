import 'dart:convert';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/screens/homepage/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:bunk_mate/controllers/auth/login_controller.dart';
import 'dart:core';

class SignupController extends GetxController {
  final LoginController _loginController = Get.find();
  
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> signUpFunction() async {
    // Validate input fields
    if (usernameController.text.isEmpty || 
        passwordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    // Check if passwords match
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    // Set loading state
    isLoading.value = true;

    var headers = {"Content-Type": "application/json"};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);
      String body = jsonEncode({
        'username': usernameController.value.text,
        'password': passwordController.value.text
      });
 
      http.Response response = await http.post(url, body: body, headers: headers);
      
      if (response.statusCode == 201) {
        // Automatically log in the user after successful signup
        await _autoLogin();
      } else {
        // Handle signup error
        isLoading.value = false;
        throw jsonDecode(response.body) ?? 'Unknown Error occurred';
      }
    } catch (error) {
      // Handle any exceptions
      isLoading.value = false;
      _showErrorDialog(error.toString());
    }
  }

  Future<void> _autoLogin() async {
    try {
      // Set login controller's text fields
      _loginController.usernameController.text = usernameController.text;
      _loginController.passwordController.text = passwordController.text;

      // Use existing login function
      bool loginSuccess = await _loginController.loginFunction();

      if (loginSuccess) {
        // Clear controllers
        usernameController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        // Navigate to HomePage
        Get.offAll(() => const HomePage());
      } else {
        // If login fails after signup
        isLoading.value = false;
        _showErrorDialog('Signup successful, but automatic login failed');
      }
    } catch (error) {
      isLoading.value = false;
      _showErrorDialog('Error during automatic login: ${error.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}