import 'package:bunk_mate/controllers/auth/signup_controller.dart';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/screens/auth/widgets/auth_button.dart';
import 'package:bunk_mate/screens/auth/widgets/auth_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final SignupController signupController = SignupController();

  @override
  void initState() {
    super.initState();
    signupController.usernameController = TextEditingController();
    signupController.passwordController = TextEditingController();
    signupController.confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    signupController.usernameController.dispose();
    signupController.passwordController.dispose();
    signupController.confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontFamily: GoogleFonts.lexend().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: screenHeight * 0.05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  AuthField(
                    controller: signupController.usernameController,
                    title: "Username",
                    isObscure: false,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  AuthField(
                    controller: signupController.passwordController,
                    title: "Password",
                    isObscure: true,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  AuthField(
                    controller: signupController.confirmPasswordController,
                    title: "Confirm Password",
                    isObscure: true,
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  AuthButton(
                    function: signupController.signUpFunction,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Column(
                    children: [
                      Text(
                        "Have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(AuthScreen());
                        },
                        child: Text(
                          "Sign in",
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
    );
  }
}
