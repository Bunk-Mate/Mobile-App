import 'package:attendence1/pages/navigator.dart';
import 'package:attendence1/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:attendence1/global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String username = UserNameController.text;

  final storage = const FlutterSecureStorage();
  final loginUrl = "$apiUrl/login";
  // ignore: non_constant_identifier_names
  TextEditingController UserNameController = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController PasswordController = TextEditingController();
  Future<dynamic> sendPostRequest() async {
    var response = await http.post(Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": UserNameController.text,
          "password": PasswordController.text,
        }));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 202) {
      String token = jsonDecode(response.body)["token"];

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign in Succesfull"),
      ));
      await storage.write(key: 'token', value: token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sign in, please try again"),
      ));
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.black12,
            Colors.black26,
            Color.fromARGB(255, 13, 15, 21),
            Colors.black,
            Color.fromARGB(255, 7, 9, 15)
          ])),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 7, 9, 15),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                            Color.fromARGB(255, 13, 15, 21),
                            Color.fromARGB(255, 7, 9, 15)
                          ])),
                      // color: Color.fromARGB(255, 13, 15, 21),

                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 55,
                            height: 55,
                          ),
                          TextField(
                            controller: UserNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: 'Username',
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Color.fromARGB(255, 17, 20, 27)),
                          ),
                          const SizedBox(
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
                            style: const TextStyle(
                              color: Colors
                                  .white, // This sets the color of the text
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                            height: 10,
                          ),
                          const SizedBox(
                            width: 50,
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  sendPostRequest().then(
                                    (response) => {
                                      if (response.statusCode == 202)
                                        {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Navigation()),
                                          )
                                        }
                                    },
                                  );
                                },
                                child: Container(
                                  width: 405,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                      child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'alpha'),
                                  )),
                                )),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Don't have an account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                width: 25,
                                height: 2,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupPage()),
                                    );
                                  },
                                  child: const Text("Signup ? ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
