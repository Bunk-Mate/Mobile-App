import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:attendence1/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

bool coursePresent = false;
late int _day;
late int hello;
List<IconData> subjectIcons = [
  Icons.school,
  Icons.book,
  Icons.star,
  Icons.people,
  Icons.abc,
  Icons.laptop_chromebook_outlined,
  Icons.macro_off,
  Icons.work,
  Icons.home,
  Icons.music_note,
  Icons.sports_soccer,
  Icons.local_movies,
  Icons.restaurant,
  Icons.directions_run,
  Icons.build,
  Icons.airplanemode_active,
  Icons.beach_access,
  Icons.shopping_cart,
  Icons.local_hospital,
  Icons.local_florist,
  Icons.brush,
  Icons.business_center,
  Icons.cake,
  Icons.camera,
  Icons.train,
  Icons.phone,
  Icons.pets,
  Icons.local_pizza,
  Icons.wifi,
  Icons.palette,
  Icons.play_circle_filled,
  Icons.favorite,
  Icons.radio,
  Icons.beenhere,
  Icons.casino,
  Icons.child_friendly,
  Icons.create,
  Icons.desktop_windows,
  Icons.directions_bike,
  Icons.emoji_food_beverage,
  Icons.flash_on,
  Icons.golf_course,
  Icons.pool,
  Icons.shopping_basket,
  Icons.star_border,
  Icons.videogame_asset,
  Icons.local_laundry_service,
  Icons.toys,
  Icons.watch,
  Icons.local_dining,
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

  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    return token;
  }

  Future<dynamic> getStatus({DateTime? date}) async {
    if (date == null) {
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
      String today = DateFormat('yyyy-MM-dd').format(date);
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

  Future<dynamic> updateStatus(String url, String status) async {
    final response = await http.patch(
      Uri.parse(url),
      //http://8204-2401-4900-32f5-8fbf-3bb0-90ee-d369-d2bb.ngrok-free.app/session/32498
      body: jsonEncode({"status": status}),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      getStatus();
      // Signal the statistics page to update on navigation
      statsUpdate = true;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to update status');
    }
  }

  void addHoliday() async {
    final response = await http.post(
      Uri.parse(apiUrl + "/schedule_selector"),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: jsonEncode(
        {"day_of_week": _day},
      ),
    );
    if (response.statusCode == 201) {
      print(hello);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("TimeTable Selected"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("TimeTable not Selected"),
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
          actions: [Row(
            children: [
              Text(
                currentDay,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
              ),SizedBox(width: 75,),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 211, 255, 153),
                    )),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child:
                        Text("REWIND TIME", style: TextStyle(color: Colors.black))),
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
                              updateStatus(
                                  courses[index]["session_url"], "bunked");
                            },
                            onDoubleTap: () {
                              updateStatus(
                                  courses[index]["session_url"], "cancelled");
                            },
                            onLongPress: () {
                              //courses[index]["status"] = "Present";
                              updateStatus(
                                  courses[index]["session_url"], "present");
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
                                    trailing: Text(
                                      "$status",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
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
                            "Select Schedule for the day : ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'alpha',
                                fontSize: 25,
                                fontWeight: FontWeight.w100),
                          )),
                          SizedBox(
                            width: 30,
                            height: 30,
                          ),

                          DropdownMenu(
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
                              getStatus();
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
