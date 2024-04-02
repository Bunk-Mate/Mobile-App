import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:attendence1/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';

Map<int, String> days = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
};
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class TimeTableEntry extends StatefulWidget {
  @override
  State<TimeTableEntry> createState() => TimeTableEntryState();
}


List<IconData> subjectIcons = [
  Icons.school,
  // Icons.book,
  // Icons.star,
  // Icons.people,
  // Icons.abc,
  // Icons.laptop_chromebook_outlined,
  // Icons.macro_off,
  // Icons.work,
  // Icons.home,
  // Icons.music_note,
  // Icons.sports_soccer,
  // Icons.local_movies,
  // Icons.restaurant,
  // Icons.directions_run,
  // Icons.build,
  // Icons.airplanemode_active,
  // Icons.beach_access,
  // Icons.shopping_cart,
  // Icons.local_hospital,
  // Icons.local_florist,
  // Icons.brush,
  // Icons.business_center,
  // Icons.cake,
  // Icons.camera,
  // Icons.train,
  // Icons.phone,
  // Icons.pets,
  // Icons.local_pizza,
  // Icons.wifi,
  // Icons.palette,
  // Icons.play_circle_filled,
  // Icons.favorite,
  // Icons.radio,
  // Icons.beenhere,
  // Icons.casino,
  // Icons.child_friendly,
  // Icons.create,
  // Icons.desktop_windows,
  // Icons.directions_bike,
  // Icons.emoji_food_beverage,
  // Icons.flash_on,
  // Icons.golf_course,
  // Icons.pool,
  // Icons.shopping_basket,
  // Icons.star_border,
  // Icons.videogame_asset,
  // Icons.local_laundry_service,
  // Icons.toys,
  // Icons.watch,
  // Icons.local_dining,
];

class TimeTableEntryState extends State<TimeTableEntry> {
  List<dynamic> courses = [];
  Map<String, dynamic> schedule = {};
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  Future<dynamic> getSchedule() async {
    final response = await http.get(
      Uri.parse('$apiUrl/schedules'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        schedule = jsonDecode(response.body);
      });
      getScheduleList();
    } else {
      throw Exception('Failed to retrieve schedule');
    }
  }

  getCourses() async {
    final response = await http.get(
      Uri.parse('$apiUrl/courses'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        courses = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to retrieve courses');
    }
  }

  Future<dynamic> logout() async {
    final response = await http.post(
      Uri.parse('$apiUrl/logout'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to retrieve statistics');
    }
  }

  List<Map<String, dynamic>> schedule_list = [];
  void getScheduleList() {
    schedule_list.clear();
    schedule.forEach((key, value) {
      schedule_list.add({key: value});
    });
  }

  @override
  void initState() {
    getSchedule();
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }

    void _settingModalBottomSheet(context) {
      late int _day;
      String _course = "Course";
      late String _scheduleUrl;
      bool _useCourseDropDown = true;
      TextEditingController _courseTextFieldController =
          TextEditingController();

      void activateDropDown() {
        setState(() {
          _useCourseDropDown = true;
        });
      }

      void clearDropDown() {
        setState(() {
          _useCourseDropDown = false;
        });
      }

      void addSchedule() async {
        final response = await http.post(
          Uri.parse(_scheduleUrl),
          headers: {
            HttpHeaders.authorizationHeader: "Token ${await getToken()}",
            HttpHeaders.contentTypeHeader: "application/json"
          },
          body: jsonEncode({"day_of_week": _day}),
        );
        if (response.statusCode == 201) {
          Navigator.pop(context);
          getSchedule();
          // Signal updates on navigation
          statusUpdate = true;
          statsUpdate = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Schedule has been added for pre-existing course!"),
            ),
          );
        } else {
          print(response.body);
          print(response.statusCode);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to add Schedule"),
            ),
          );
          throw Exception('Failed to add schedule for pre-existing course');
        }
      }

      void addCourse() async {
        final response = await http.post(
          Uri.parse("$apiUrl/courses"),
          headers: {
            HttpHeaders.authorizationHeader: "Token ${await getToken()}",
            HttpHeaders.contentTypeHeader: "application/json"
          },
          body: jsonEncode(
            {
              "name": _course,
              "schedules": {"day_of_week": _day},
            },
          ),
        );
        if (response.statusCode == 201) {
          Navigator.pop(context);
          getSchedule();
          statusUpdate = true;
          statsUpdate = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Course had been added!"),
            ),
          );
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to add course!"),
            ),
          );
          throw Exception('Failed to add course!');
        }
      }

      void submit() {
        // If course already exists, just add a new schedule
        if (_useCourseDropDown) {
          addSchedule();
        } else {
          addCourse();
        }
        // _courseTextFieldController.dispose();
      }

      showModalBottomSheet(
          backgroundColor: Color.fromARGB(255, 13, 15, 21),
          context: context,
          builder: (context) => SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _courseTextFieldController,
                          onChanged: (courseName) {
                            if (courseName.isEmpty) {
                              _course = "Course";
                              activateDropDown();
                              addSchedule();
                            } else {
                              _course = courseName;
                              clearDropDown();
                              addSchedule();
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 211, 255, 153),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Enter your Subject Name',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownMenu<int>(
                              inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fillColor: Color.fromARGB(255, 211, 255, 153),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              hintText: "Day",
                              onSelected: (day) {
                                _day = day!;
                              },
                              dropdownMenuEntries: days.entries.map(
                                (day) {
                                  return DropdownMenuEntry<int>(
                                    value: day.key,
                                    label: day.value,
                                  );
                                },
                              ).toList(),
                            ),
                            FutureBuilder(
                              future: getCourses(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return DropdownMenu<String>(
                                    width: MediaQuery.of(context).size.width *
                                        0.44,
                                    inputDecorationTheme: InputDecorationTheme(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        fillColor:
                                            Color.fromARGB(255, 211, 255, 153),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    initialSelection: _useCourseDropDown
                                        ? null
                                        : "New Course",
                                    hintText: "Course",
                                    onSelected: (scheduleUrl) {
                                      _courseTextFieldController.clear();
                                      activateDropDown();
                                      _scheduleUrl = scheduleUrl!;
                                    },
                                    dropdownMenuEntries: _useCourseDropDown
                                        ? courses.map(
                                            (course) {
                                              String courseName =
                                                  course["name"]!;
                                              return DropdownMenuEntry<String>(
                                                value: course["schedules_url"]!,
                                                label: courseName,
                                                labelWidget: Text(
                                                  courseName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            },
                                          ).toList()
                                        : courses.map(
                                              (course) {
                                                String courseName =
                                                    course["name"]!;
                                                return DropdownMenuEntry<
                                                    String>(
                                                  value:
                                                      course["schedules_url"]!,
                                                  label: courseName,
                                                  labelWidget: Text(
                                                    courseName,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                );
                                              },
                                            ).toList() +
                                            [
                                              const DropdownMenuEntry(
                                                value: "New Course",
                                                label: "New Course",
                                              )
                                            ],
                                  );
                                }
                              },
                            ),
                            
                          ],
                        ),
                        Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 211, 255, 153),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: submit,
                                child: Text("Submit")))
                      ],
                    )),
              ));
    }

    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _settingModalBottomSheet(context);
              },
              backgroundColor: Color.fromARGB(255, 211, 255, 153),
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            backgroundColor: Color.fromARGB(255, 7, 9, 15),
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
                      final itemList =
                          (dayData[dayName] as List<dynamic>?) ?? [];
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
            )));
  }
}
