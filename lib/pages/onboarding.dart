import 'package:attendence1/pages/subject.dart';
import 'package:flutter/material.dart';
import 'package:attendence1/global.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:attendence1/pages/homepage.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

dynamic days = [];
bool checkBox = false;

class _OnBoardState extends State<OnBoard> {
  final GlobalKey<HomePageState> _statsGlobalKey = GlobalKey();
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
        "courses_data": [],
        "shared": checkBox
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
      // Signal updates on navigation
      statusUpdate = true;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/mainPage', (route) => false);
      _statsGlobalKey.currentState?.getStats();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable has been created"),
        ),
      );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not create timetable"),
        ),
      );
      throw Exception("Could not create timetable");
    }
  }

  void timeTablePresets() async {
    final response = await http.post(
      Uri.parse("$apiUrl/collection_selector"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode({"copy_id": _copyid}),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
      // Signal updates on navigation
      statsUpdate = true;
      // getTimeTable();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Timetable has been updated"),
        ),
      );
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not update timetable"),
        ),
      );
      throw Exception('Failed to update timetable');
    }
  }

  late List<dynamic> hello = [];
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showAlertDialog(BuildContext context) {
      // set up the button
      Widget yesButton = TextButton(
        child: const Text("Yes"),
        onPressed: () {
          timeTablePresets();
          statusUpdate = true;
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/mainPage', (route) => false);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Are you sure ? "),
        content:
            const Text("You would lose all your current data if you did this."),
        actions: [yesButton],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    // showAlertDialog1(BuildContext context) {
    //   // set up the button
    //   Widget yesButton = TextButton(
    //     child: const Text("Yes"),
    //     onPressed: () {
    //      submitTimetable();
    //       statusUpdate = true;
    //       statsUpdate = true;
    //       Navigator.of(context).pushNamedAndRemoveUntil('/mainPage', (route) => false);
    //     },
    //   );

    //   // set up the AlertDialog
    //   AlertDialog alert = AlertDialog(
    //     title: const Text("Are you sure ? "),
    //     content: const Text("You would lose all your current data if you did this."),
    //     actions: [yesButton],
    //   );

    //   // show the dialog
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return alert;
    //     },
    //   );
    // }

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
                      )),
                    ],
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 24, top: 24),
                child: DropdownMenuItem(
                  child: Center(
                    child: FutureBuilder(
                      future: getTimeTable(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownMenu(
                            hintText: 'TimeTable Presets',
                            expandedInsets: const EdgeInsets.all(7),
                            inputDecorationTheme: const InputDecorationTheme(
                              fillColor: Color.fromARGB(255, 7, 9, 15),
                              hintStyle: TextStyle(color: Colors.white24),
                            ),
                            dropdownMenuEntries: hello.map(
                              (days) {
                                return DropdownMenuEntry<String>(
                                    value: days["name"], label: days["name"]);
                              },
                            ).toList(),
                            onSelected: (days) {
                              var selectedEntry = hello.firstWhere(
                                  (element) => element["name"] == days);
                              int selectedId = selectedEntry["id"];
                              _copyid = selectedId;
                              showAlertDialog(context);
                            },
                          );
                        }
                      },
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
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
                    const SizedBox(
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

                        style: const TextStyle(color: Colors.white24),
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
                    const SizedBox(
                      width: 25,
                      height: 25,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: width / 2.6,
                            child: DateTimeFormField(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 211, 255, 153),
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: "alpha"),
                              mode: DateTimeFieldPickerMode.date,
                              onChanged: (DateTime? startDate) => _startDate =
                                  DateFormat("yyyy-MM-dd").format(startDate!),
                            )),
                        const Spacer(),
                        SizedBox(
                            width: width / 2.6,
                            child: DateTimeFormField(
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
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: "alpha"),
                              mode: DateTimeFieldPickerMode.date,
                              initialPickerDateTime: DateTime.now(),
                              onChanged: (DateTime? endDate) => _endDate =
                                  DateFormat('yyyy-MM-dd').format(endDate!),
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 500,
                      height: 25,
                    ),
                    CheckboxListTile(
                      title: const Text(
                        "Share TimeTable",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w100),
                      ),
                      value: checkBox,
                      onChanged: (newValue) {
                        setState(() {
                          checkBox = newValue!;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          if (_endDate.isNotEmpty &&
                              _startDate.isNotEmpty &&
                              _timeTableName.isNotEmpty &&
                              _minAttendence != 0) {
                            submitTimetable();
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
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
