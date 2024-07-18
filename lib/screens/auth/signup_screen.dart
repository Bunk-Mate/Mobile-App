import 'package:bunk_mate/controllers/auth/signup_controller.dart';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/screens/auth/widgets/auth_button.dart';
import 'package:bunk_mate/screens/auth/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    SignupController signupController = SignupController();
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 192, 252, 96),
                        Color.fromARGB(255, 212, 252, 96),
                        Color.fromARGB(255, 232, 252, 116),
                        Color.fromARGB(255, 252, 252, 136),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    )),
                child: Column(
                  children: [
                    SafeArea(
                        child: Text("Register",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontFamily: GoogleFonts.lexend().fontFamily,
                            ))),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 55,
                        height: 55,
                      ),
                      AuthField(
                        controller: signupController.usernameController,
                        title: "Username",
                        isObscure: false,
                      ),
                      const SizedBox(
                        width: 25,
                        height: 25,
                      ),
                      AuthField(
                        controller: signupController.passwordController,
                        title: "Password",
                        isObscure: true,
                      ),
                      const SizedBox(
                        width: 25,
                        height: 25,
                      ),
                      AuthField(
                        controller: signupController.confirmPasswordController,
                        title: "Confirm Password",
                        isObscure: true,
                      ),
                      const SizedBox(
                        width: 50,
                        height: 50,
                      ),
                      AuthButton(
                          function: signupController.signUpFunction,
                          screenWidth: screenWidth),
                      Column(
                        children: [
                          const SizedBox(width: 10, height: 10),
                          const Text(
                            "Have an account",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(AuthScreen());
                              },
                              child: const Text("Sign in",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
