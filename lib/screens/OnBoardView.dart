import 'package:bunk_mate/controllers/onBoard/time_table_controller.dart';
import 'package:bunk_mate/models/onboard_time_table.dart';
import 'package:bunk_mate/utils/custom_date_picker.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 13, 15, 21),
              height: 200,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Center(
                        child: Text("Timetable Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            fontFamily: 'alpha')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24, right: 24, bottom: 24, top: 24),
              child: DropdownButtonFormField(
                items: _presets.map((preset) {
                  return DropdownMenuItem(
                    value: preset['id'],
                    child: Text(preset['name']),
                  );
                }).toList(),
                hint: const Text('Timetable Presets'),
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
                              _controller.timeTablePresets(value as int).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Timetable has been updated")),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Could not update timetable")),
                                );
                              });
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
                    onChanged: (minAttendance) =>
                      _minAttendance = int.parse(minAttendance),
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
