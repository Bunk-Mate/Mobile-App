import 'package:bunk_mate/screens/auth/signup_screen.dart';
import 'package:bunk_mate/screens/auth/widgets/auth_field.dart';
import 'package:bunk_mate/utils/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:bunk_mate/controllers/auth/login_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: screenSize.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 192, 252, 96),
                      Color.fromARGB(255, 212, 252, 96),
                      Color.fromARGB(255, 232, 252, 116),
                      Color.fromARGB(255, 252, 252, 136),
                      Color.fromARGB(255, 252, 252, 188),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SafeArea(
                          child: Text(
                            "Sign in to your account",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              fontFamily: GoogleFonts.lexend().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.9,
                      height: screenSize.height * 0.05,
                    ),
                    AuthField(
                      controller: loginController.usernameController,
                      title: "Username",
                      isObscure: false,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.9,
                      height: screenSize.height * 0.03,
                    ),
                    AuthField(
                      controller: loginController.passwordController,
                      title: "Password",
                      isObscure: true,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.9,
                      height: screenSize.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          bool success = await loginController.loginFunction();
                          if (success) {
                            Get.to(const Navigation());
                          }
                        },
                        child: Container(
                          width: screenSize.width * 0.75,
                          height: screenSize.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(255, 212, 252, 96),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.lexend().fontFamily,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          "Don't have an account",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
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
                                builder: (context) => const Registration(),
                              ),
                            );
                          },
                          child: const Text(
                            "Signup ? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
