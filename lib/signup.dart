// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:attendence1/global.dart';
import 'package:attendence1/login.dart';
import 'package:attendence1/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final signUpUrl = apiUrl + '/register';
  TextEditingController UserNameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  Future<void> sendPostRequest() async {
    var response = await http.post(Uri.parse(signUpUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": UserNameController.text,
          "password": PasswordController.text,
        }));

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("SignUp Succesfull"),
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
      body: SingleChildScrollView( child:Column(
        children: [
          Container(
              color: Color.fromARGB(255, 13, 15, 21),
              width: 500,
              height: 175,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SafeArea(
                        child: Text("Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                fontFamily: 'alpha'))),
                  ],
                ),
              )),
          Padding(
              padding: EdgeInsets.all(24),
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
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27)),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'E-Mail',
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
                    
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27)),
                    obscureText: true,
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                  ),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27)),
                    obscureText: true,
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
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
                            "Signup",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                          width: 405,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "Have an account",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          child: Container(
                            child: Text("Sign in",
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
    ));
  }
}
