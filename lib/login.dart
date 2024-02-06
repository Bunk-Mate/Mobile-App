import 'package:attendence1/homepage.dart';
import 'package:attendence1/onboarding.dart';
import 'package:attendence1/signup.dart';
import 'package:attendence1/subject.dart';
import 'package:attendence1/timetable.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final apiUrl =
      "https://1a39-2401-4900-2621-1db0-b3be-c063-762b-4f48.ngrok-free.app/login";
  TextEditingController UserNameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  Future<void> sendPostRequest() async {
    var response = await http.post(Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": UserNameController.text,
          "password": PasswordController.text,
        }));

    if (response.statusCode == 202) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign Succesfull"),
      ));
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Your Password is weak/User already exists"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      body: Center(
        child: Column(
          children: [
            Container(
                color: Color.fromARGB(255, 13, 15, 21),
                width: 500,
                height: 245,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SafeArea(
                            child: Text("Sign in to your account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40,
                                    fontFamily: 'alpha'))),
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                    ),
                    TextField(
                      controller: UserNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Color.fromARGB(255, 17, 20, 27)),
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                    ),
                    TextField(
                      controller: PasswordController,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Color.fromARGB(255, 17, 20, 27)),
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white, // This sets the color of the text
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                    SizedBox(
                      width: 50,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            sendPostRequest();
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'alpha'),
                            )),
                            width: 405,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          )),
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            "Don't have an account",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                            },
                            child: Container(
                              child: Text("Signup ? ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
