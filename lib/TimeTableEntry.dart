import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:attendence1/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';

List<String> days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
String currentDay = days[0];
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class TimeTableEntry extends StatefulWidget {
  const TimeTableEntry({super.key});

  @override
  State<TimeTableEntry> createState() => _TimeTableEntryState();
}

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

class _TimeTableEntryState extends State<TimeTableEntry> {
  Future<void> showAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Period"),
            content: const Text("This is a test dialog"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  Map<String, dynamic> schedule = {
    // "monday": [
    //   {"url": "http://127.0.0.1:8000/schedule/440", "name": "geometry"},
    //   {"url": "http://127.0.0.1:8000/schedule/425", "name": "maths"},
    //   {"url": "http://127.0.0.1:8000/schedule/434", "name": "algebra"},
    //   {"url": "http://127.0.0.1:8000/schedule/443", "name": "calculus"},
    // ],
    // "tuesday": [
    //   {"url": "http://127.0.0.1:8000/schedule/435", "name": "literature"},
    //   {"url": "http://127.0.0.1:8000/schedule/426", "name": "English"},
    //   {"url": "http://127.0.0.1:8000/schedule/427", "name": "English"},
    //   {"url": "http://127.0.0.1:8000/schedule/436", "name": "literature"}
    // ],
    // "wednesday": [
    //   {"url": "http://127.0.0.1:8000/schedule/441", "name": "world history"},
    //   {"url": "http://127.0.0.1:8000/schedule/444", "name": "US history"},
    //   {"url": "http://127.0.0.1:8000/schedule/428", "name": "history"},
    //   {"url": "http://127.0.0.1:8000/schedule/437", "name": "geography"}
    // ],
    // "thursday": [
    //   {"url": "http://127.0.0.1:8000/schedule/429", "name": "chemistry"},
    //   {"url": "http://127.0.0.1:8000/schedule/438", "name": "biology"},
    //   {"url": "http://127.0.0.1:8000/schedule/430", "name": "chemistry"},
    //   {"url": "http://127.0.0.1:8000/schedule/432", "name": "physics"}
    // ],
    // "friday": [
    //   {"url": "http://127.0.0.1:8000/schedule/439", "name": "computer science"},
    //   {"url": "http://127.0.0.1:8000/schedule/431", "name": "physics"},
    //   {"url": "http://127.0.0.1:8000/schedule/433", "name": "physics"},
    //   {"url": "http://127.0.0.1:8000/schedule/442", "name": "art"}
    // ]
  };
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  Future<dynamic> getSchedule() async {
    print(
        "= = = === === = ==  SCHEDULE HAVE BEEN UPDATED! =  ===== = == == == ");
    final response = await http.get(
      Uri.parse(apiUrl + '/schedules'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        schedule = jsonDecode(response.body);
      });
      print(schedule);
      getList();
    } else {
      throw Exception('Failed to retrieve schedule');
    }
  }

  Future<dynamic> logout() async {
    final response = await http.post(
      Uri.parse(apiUrl + '/logout'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      print("It works");
    } else {
      throw Exception('Failed to retrieve statistics');
    }
  }

  List<Map<String, dynamic>> schedule_list = [];
  void getList() {
    schedule.forEach((key, value) {
      schedule_list.add({key: value});
    });
  }

  @override
  void initState() {
    currentDay = days[0];
    getSchedule();

    print(schedule);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }

    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          backgroundColor: Color.fromARGB(255, 13, 15, 21),
          context: context,
          builder: (BuildContext bc) {
            return Padding(
                padding: const EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 211, 255, 153),
                            border: OutlineInputBorder(),
                            hintText: 'Enter your Subject Name(New**)',
                          ),
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 25,
                                height: 25,
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    fillColor:
                                        Color.fromARGB(255, 211, 255, 153),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                isExpanded: true,
                                value: currentDay,
                                items: days.map((String e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() {
                                      currentDay = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 211, 255, 153),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              isExpanded: true,
                              value: currentDay,
                              items: days.map((String e) {
                                return DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    currentDay = value;
                                  });
                                }
                              },
                            ),
                            Text(currentDay),
                            ElevatedButton(
                                onPressed: () {}, child: Text("Submit"))
                          ],
                        )),
                      ],
                    ),
                  ),
                ));
          });
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 7, 9, 15),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _settingModalBottomSheet(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: Center(
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: schedule_list.length,
                itemBuilder: (BuildContext context, int index) {
                  final dayData = schedule_list[index];
                  final dayName = dayData.keys.first;
                  final itemList = (dayData[dayName] as List<dynamic>?) ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                              child: Text(dayName.toString().toTitleCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)))),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemList.length,
                        itemBuilder: (BuildContext context, int itemIndex) {
                          final item = itemList[itemIndex];
                          final itemName = item['name'];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(255, 13, 15, 21)),
                                child: ListTile(
                                  leading: Icon(
                                    getRandomSubjectIcon(),
                                    size: 62,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    itemName.toString().toTitleCase(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ));
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              )),
            ],
          )),
        ));
  }
}
