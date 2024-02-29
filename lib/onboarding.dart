import 'package:flutter/material.dart';
import 'package:attendence1/global.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

dynamic days = [];

class _OnBoardState extends State<OnBoard> {
  String _timeTableName = "";
  int _minAttendence = 0;
  String _startDate = "";
  String _endDate = "";
  int _copyid = 0;

  final storage = const FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  void submitTimetable() async {
    final response = await http.post(
      Uri.parse("$apiUrl/collection"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({
        "name": _timeTableName,
        "start_date": _startDate,
        "end_date": _endDate,
        "courses_data": []
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
      // Signal updates on navigation
      statsUpdate = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable details have been updated"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not update timetable details"),
        ),
      );
      throw Exception('Failed to add schedule for pre-existing course');
    }
  }

  void timeTablePresets() async {
    final response = await http.post(
      Uri.parse("$apiUrl/collection_selector"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"copy_id": 20}),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
      // Signal updates on navigation
      statsUpdate = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable details have been updated"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not update timetable details"),
        ),
      );
      throw Exception('Failed to add schedule for pre-existing course');
    }
  }

  List<dynamic> hello = [];
  // ignore: non_constant_identifier_names
  Future<dynamic> getTimeTable() async {
    final response = await http.get(Uri.parse("$apiUrl/collections"), headers: {
      HttpHeaders.authorizationHeader: "Token ${await getToken()}",
    });
    if (response.statusCode == 200) {
      hello = jsonDecode(response.body);
      print(hello);
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    getTimeTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: Color.fromARGB(255, 13, 15, 21),
                height: 200,
                child: Padding(
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
                      )),
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (timeTableName) =>
                          _timeTableName = timeTableName,
                      decoration: const InputDecoration(
                        hintText: 'TimeTable Name',
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
                    SizedBox(
                      width: 25,
                      height: 25,
                    ),
                    TextFormField(
                        onChanged: (minAttendence) =>
                            _minAttendence = int.parse(minAttendence),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered

                        style: TextStyle(color: Colors.white24),
                        decoration: const InputDecoration(
                          hintText: 'Minimum Attendence %',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: Color.fromARGB(255, 17, 20, 27),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 211, 255, 153),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 25,
                      height: 25,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 211, 255, 153),
                          ),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "alpha"),
                      mode: DateTimeFieldPickerMode.date,
                      onChanged: (DateTime? startDate) => _startDate =
                          DateFormat("yyyy-MM-dd").format(startDate!),
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                    ),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                        labelText: 'End Date',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 211, 255, 153),
                          ),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "alpha"),
                      mode: DateTimeFieldPickerMode.date,
                      initialPickerDateTime: DateTime.now(),
                      onChanged: (DateTime? endDate) =>
                          _endDate = DateFormat('yyyy-MM-dd').format(endDate!),
                    ),
                    SizedBox(
                      width: 500,
                      height: 25,
                    ),
                    DropdownMenuItem(
                      child: Center(
                        child: FutureBuilder(
                          future: getTimeTable(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return DropdownMenu(
                                expandedInsets: EdgeInsets.all(7),
                                inputDecorationTheme: InputDecorationTheme(
                                  fillColor: Color.fromARGB(255, 7, 9, 15),
                                ),
                                dropdownMenuEntries: hello.map(
                                  (days) {
                                    return DropdownMenuEntry<String>(
                                        value: days["name"], label: days["name"]);
                                  },
                                ).toList(),
                                onSelected: (days) {
                                  var selectedEntry = hello.firstWhere((element) => element["name"] == days);
    int selectedId = selectedEntry["id"];
    _copyid = selectedId;
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (_endDate.isNotEmpty &&
                              _startDate.isNotEmpty &&
                              _timeTableName.isNotEmpty &&
                              _minAttendence != 0) {
                            submitTimetable();
                          } else if (_endDate != 0) {
                            timeTablePresets();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter all details!"),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Center(
                              child: Text(
                                "NEXT",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            width: 405,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
