import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final Function(DateTime?) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    required this.onDateSelected, 
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 211, 255, 153),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontFamily: "alpha",
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}