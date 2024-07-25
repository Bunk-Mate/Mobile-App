import 'package:bunk_mate/controllers/onBoard/time_table_controller.dart';
import 'package:bunk_mate/models/onboard_time_table.dart';
import 'package:bunk_mate/utils/Navigation.dart';
import 'package:bunk_mate/utils/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final TimetableController _controller = TimetableController();
  String _timeTableName = "";
  int _minAttendance = 0;
  String _startDate = "";
  String _endDate = "";
  bool _isShared = false;
  late List<dynamic> _presets = [];

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    _presets = await _controller.getTimeTable();
    setState(() {});
  }

  void _submit() {
    if (_endDate.isNotEmpty &&
        _startDate.isNotEmpty &&
        _timeTableName.isNotEmpty &&
        _minAttendance != 0) {
      TimetableModel timetable = TimetableModel(
        name: _timeTableName,
        minAttendance: _minAttendance,
        startDate: _startDate,
        endDate: _endDate,
        isShared: _isShared,
      );
      _controller.submitTimetable(timetable).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Timetable has been created")),
          
        );
        Get.off(Navigation());
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not create timetable")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all details!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 9, 15),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 14),
        child: Container(
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
          child: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 12,
            actions: [
              Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter, 
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
                          child: Text(
                            "Timetable Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              fontFamily: GoogleFonts.lexend().fontFamily),
                          ),
                        ),
                      ),
                    SizedBox(width: MediaQuery.of(context).size.width / 6 ),],
                  ),
                ],
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24, right: 24, bottom: 24, top: 24),
              child: DropdownButtonFormField(
                items: _presets.map((preset) {
                  hintText: const Text('Timetable Presets', style: TextStyle(color: Colors.white24));
                  return DropdownMenuItem(
                    value: preset['id'],
                    child: Text(preset['name']),
                    
                  );
                }).toList(),
                hint: const Text('Timetable Presets', style: TextStyle(color: Colors.white24)),
                onChanged: (value) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Are you sure?"),
                        content: const Text("You would lose all your current data if you did this."),
                        actions: [
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              _controller.timeTablePresets(value as int).then((_) {
                                Get.to(Navigation());
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Could not update timetable")),
                                );
                              });
                            },
                          ),
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (timeTableName) => _timeTableName = timeTableName,
                    decoration: const InputDecoration(
                      hintText: 'Timetable Name',
                      hintStyle: TextStyle(color: Colors.white24),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 17, 20, 27),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 255, 153),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25, height: 25),
                  TextFormField(
                    onChanged: (minAttendance) {
                      try {
                        _minAttendance = int.parse(minAttendance);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a valid number")),
                        );
                      }
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white24),
                    decoration: const InputDecoration(
                      hintText: 'Minimum Attendance %',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Color.fromARGB(255, 17, 20, 27),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 211, 255, 153),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25, height: 25),
                  Row(
                    children: [
                      SizedBox(
                        width: width / 2.6,
                        child: CustomDatePicker(
                          labelText: 'Start Date',
                          onDateSelected: (date) {
                            setState(() {
                              _startDate = DateFormat("yyyy-MM-dd").format(date!);
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: width / 2.6,
                        child: CustomDatePicker(
                          labelText: 'End Date',
                          onDateSelected: (date) {
                            setState(() {
                              _endDate = DateFormat('yyyy-MM-dd').format(date!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 500, height: 25),
                  CheckboxListTile(
                    title: const Text(
                      "Share Timetable",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w100),
                    ),
                    value: _isShared,
                    onChanged: (newValue) {
                      setState(() {
                        _isShared = newValue!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: _submit,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 405,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
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
