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
    const Color cardColor = Color(0xFF1E1E1E);
    const Color textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Timetable Details',
          style: GoogleFonts.lexend(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
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
                                  Get.off( Navigation());
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
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (timeTableName) => _controller.timeTableName = timeTableName,
                decoration: const InputDecoration(
                  hintText: 'Timetable Name',
                  hintStyle: TextStyle(color: Colors.white24),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (minAttendance) {
                  try {
                   _controller.minAttendance = int.parse(minAttendance);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please enter a valid number")),
                    );
                  }
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Minimum Attendance %',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: cardColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          _controller.startDate.value =
                              DateFormat("yyyy-MM-dd").format(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(),
                        ),
                        child: Obx(
                          () => Text(
                            _controller.startDate.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          _controller.endDate.value =
                              DateFormat("yyyy-MM-dd").format(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(),
                        ),
                        child: Obx(
                          () => Text(
                            _controller.endDate.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _controller.submit,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF4CAF50),
                  ),
                  child: const Center(
                    child: Text(
                      "NEXT",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
