import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField(
      {super.key,
      required this.controller,
      required this.title,
      required this.isObscure});

  final TextEditingController controller;
  final String title;
  final bool isObscure;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: title,
          border: const OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: const Color.fromARGB(255, 17, 20, 27)),
      obscureText: isObscure,
    );
  }
}
