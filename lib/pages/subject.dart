import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:attendence1/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:attendence1/utls/imp.dart';

bool coursePresent = false;
bool isHoliday = false;
late int _day;
late int hello;
List<IconData> subjectIcons = [
  Icons.school,
];

Future<void> getStatus() async {
  final state = TimeTableState();
  await state.getStatus();
}

Map<int, String> days = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};

class TimeTable extends StatefulWidget {
  TimeTable({required Key key}) : super(key: key);
  @override
  State<TimeTable> createState() => TimeTableState();
}

class TimeTableState extends State<TimeTable> with RouteAware {
  dynamic courses = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  String color = '';
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    return token;
  }

  Future<dynamic> getStatus({DateTime? date}) async {
    
    if (date == null && isHoliday == false) {
      DateTime now = new DateTime.now();
      String today = DateFormat('yyyy-MM-dd').format(now);
      final response = await http.get(
        Uri.parse(apiUrl + '/datequery?date=$today'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          courses = jsonDecode(response.body);
          print(courses);
          print(response.body);
        });
        statusUpdate = false;
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to retrieve status');
      }
      return today;
    } else {
      print("I am inside the function that should be actually called");
      String today = DateFormat('yyyy-MM-dd').format(date!);
      print(today);
      final response = await http.get(
        Uri.parse(apiUrl + '/datequery?date=$today'),
        headers: {
          HttpHeaders.authorizationHeader: "Token ${await getToken()}",
          HttpHeaders.contentTypeHeader: "application/json"
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          courses = jsonDecode(response.body);
          print(courses);
          print(response.body);
          print(response.statusCode);
        });
        statusUpdate = false;
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to retrieve status');
      }
      return today;
    }
  }

  Future<dynamic> updateStatus(String url, String status,{DateTime? date}) async {
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode({"status": status}),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      if (date == null) {
         getStatus();
      }
      else {
        getStatus(date: date);
      }
     
      // Signal the stati
      //stics page to update on navigation
      statsUpdate = true;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to update status');
    }
  }

  late Color c1;
  void addHoliday() async {
    isHoliday = true ;
    final response = await http.post(
      Uri.parse("$apiUrl/schedule_selector"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(
        {
          "day_of_week": _day,
          "date": DateFormat('yyyy-MM-dd').format(selectedDate)
        },
      ),
    );
    if (response.statusCode == 201) {
      getStatus(date: selectedDate);
      print("I am inside addHoliday");
      //_selectDate(context)

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copied Schedule"),
        ),
      );
    } else {
      print(response.statusCode);
      print(response.body);
      print(DateFormat('EEEE').format(selectedDate));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not copy schedule"),
        ),
      );
      throw Exception('Failed to add TimeTable');
    }
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print(picked);
        getStatus(date: picked);
        print(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }

    final currentDay = DateFormat('EEEE').format(DateTime.now());
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 7, 9, 15),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          actions: [
            Column(
              children: [
                Row(
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 25),
                          child: Text(
                            days[selectedDate.weekday].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32),
                          ),
                        )),
                    SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 211, 255, 153),
                          )),
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text("REWIND TIME",
                              style: TextStyle(color: Colors.black))),
                    ),
                  ],
                ),
                Divider(color: Colors.white)
              ],
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 7, 9, 15),
        ),
        body: courses.isNotEmpty
            ? ListView.builder(
                itemCount: courses.length,
                itemBuilder: (BuildContext context, int index) {
                  String name =
                      courses[index]["name"].toString().toCapitalized();
                  String status = courses[index]["status"];
                  if (status == 'bunked') {
                    c1 = Colors.red;
                  } else if (status == 'cancelled') {
                    c1 = Colors.blue.shade700;
                  } else {
                    c1 = Colors.green;
                  }
                  if (courses.isEmpty) {
                    return Container(
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Hello World")),
                    );
                  } else {
                    return Column(
                      children: [
                        if (currentDay == "Saturday") ...[
                          Container(
                            color: Colors.white,
                            width: 20000,
                            height: 20000,
                          ),
                        ],
                        GestureDetector(
                            onTap: () {
                              print("Hello i am index");
                               courses[index]["status"] = "bunked";
                               c1 = Colors.red;
                               getStatus(date: selectedDate);
                              updateStatus(
                                  courses[index]["session_url"], "bunked");
                            },
                            onDoubleTap: () {
                              courses[index]["status"] = "cancelled";
                              c1 = Colors.blue.shade700;
                              getStatus(date: selectedDate);
                              updateStatus(
                                  courses[index]["session_url"], "cancelled");
                                  getStatus(date: selectedDate);
                            },
                            onLongPress: () {
                              courses[index]["status"] = "Present";
                              c1 = Colors.green;
                              getStatus(date: selectedDate);
                              updateStatus(
                                  courses[index]["session_url"], "present");
                                  getStatus(date: selectedDate);
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 13, 15, 21)),
                                  child: ListTile(
                                    leading: Icon(
                                      getRandomSubjectIcon(),
                                      size: 32,
                                    ),
                                    iconColor: Colors.white,
                                    title: Text(
                                      "$name",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 32),
                                    ),
                                    trailing: Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: c1,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            shape: BoxShape.rectangle),
                                        child: Center(
                                          child: Text("$status",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        )),
                                  ),
                                ))),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      ],
                    );
                  }
                })
            : Center(
                child: DropdownMenuItem(
                  child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            "No Courses Scheduled Today!",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'alpha',
                                fontSize:
                                    MediaQuery.of(context).size.width / 17,
                                fontWeight: FontWeight.w100),
                          )),
                          SizedBox(
                            width: 30,
                            height: 30,
                          ),

                          DropdownMenu(
                            width: MediaQuery.of(context).size.width / 2,
                            hintText: "Copy Schedule",
                            inputDecorationTheme: InputDecorationTheme(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor:
                                    const Color.fromARGB(255, 211, 255, 153),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            dropdownMenuEntries: days.entries.map(
                              (days) {
                                return DropdownMenuEntry<int>(
                                    value: days.key, label: days.value);
                              },
                            ).toList(),
                            onSelected: (days) {
                              _day = days!;
                              addHoliday();
                            },
                          ),

                          //items.entries.map((String items) {
                          //   return DropdownMenuItem(
                          //     value: items,
                          //     child: Text(items),
                          //   );
                          // }).toList(),
                        ]),
                  ),
                ),
              ));
  }
}

