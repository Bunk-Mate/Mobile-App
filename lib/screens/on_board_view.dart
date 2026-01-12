import 'package:bunk_mate/controllers/onBoard/on_board_controller.dart';
import 'package:bunk_mate/services/on_board_service.dart';
import 'package:bunk_mate/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  final OnBoardController _controller = Get.put(OnBoardController());
  final OnBoardService _service = OnBoardService();

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFF121212);
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Timetable Details',
          style: GoogleFonts.lexend(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                    () => DropdownButtonFormField(
                  items: _controller.presets.map((preset) {
                    return DropdownMenuItem(
                      value: preset['id'],
                      child: Text(
                        preset['name'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text('Timetable Presets',
                      style: TextStyle(color: Colors.white)),
                  onChanged: (value) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text(
                              "You would lose all your current data if you did this."),
                          actions: [
                            TextButton(
                              child: const Text("Yes"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _service
                                    .timeTablePresets(value as int)
                                    .then((_) {
                                  Get.off(Navigation());
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Could not update timetable")),
                                  );
                                });
                              },
                            ),
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hintText: 'Timetable Name',
                onChanged: (timeTableName) => _controller.timeTableName = timeTableName,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                hintText: 'Minimum Attendance %',
                onChanged: (minAttendance) {
                  try {
                    _controller.minAttendance = int.parse(minAttendance);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a valid number")),
                    );
                  }
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDateSelector('Start Date', _controller.startDate),
              const SizedBox(height: 16),
              _buildDateSelector('End Date', _controller.endDate),
              const SizedBox(height: 16),
              Obx(
                    () => CheckboxListTile(
                  title: const Text(
                    "Share Timetable",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  value: _controller.isShared.value,
                  onChanged: (newValue) {
                    _controller.isShared.value = newValue!;
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    const Color cardColor = Color(0xFF1E1E1E);
    return TextField(
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: cardColor ,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        filled: true,

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  Widget _buildDateSelector(String label, RxString dateController) {
    const Color cardColor = Color(0xFF1E1E1E);
    return GestureDetector(

      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          dateController.value = DateFormat("yyyy-MM-dd").format(picked);
        }
      },
      child: InputDecorator(

        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        child: Obx(
              () => Text(
            dateController.value.isEmpty ? 'Select a date' : dateController.value,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _controller.submit,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            "NEXT",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
