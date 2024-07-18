import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.function,
    required this.screenWidth,
  });

  final VoidCallback function;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 212, 252, 96),
        foregroundColor: const Color.fromARGB(255, 212, 252, 96),
      ),
      child: Container(
        width: screenWidth / 1.5,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
            child: Text(
          "Signup",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
