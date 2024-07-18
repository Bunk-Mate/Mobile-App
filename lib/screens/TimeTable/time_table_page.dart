import 'dart:math';
import 'package:bunk_mate/controllers/timetable/time_table_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeTableEntry extends StatefulWidget {
  @override
  State<TimeTableEntry> createState() => TimeTableEntryState();
}

class TimeTableEntryState extends State<TimeTableEntry> {
  final TimeTableController controller = Get.put(TimeTableController());
  static const Map<int, String> days = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday",
};


  @override
  void initState() {
    super.initState();
    controller.getSchedule();
    controller.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _settingModalBottomSheet(context),
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
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.schedule.length,
                      itemBuilder: (context, index) {
                        final schedule = controller.schedule[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  schedule.dayOfWeek,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: schedule.courses.length,
                              itemBuilder: (context, itemIndex) {
                                final course = schedule.courses[itemIndex];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 13, 15, 21),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        getRandomSubjectIcon(),
                                        size: 62,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        course.name..capitalize,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData getRandomSubjectIcon() {
    return Icons.abc;
  }

  void _settingModalBottomSheet(BuildContext context) {
    late int _day;
    String _course = "Course";
    late String _scheduleUrl;
    bool _useCourseDropDown = true;
    TextEditingController _courseTextFieldController = TextEditingController();

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

    void submit() {
      if (_useCourseDropDown) {
        controller.addSchedule(_scheduleUrl, _day);
      } else {
        controller.addCourse(_course, _day);
      }
      _courseTextFieldController.dispose();
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
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _courseTextFieldController,
                onChanged: (courseName) {
                  if (courseName.isEmpty) {
                    _course = "Course";
                    activateDropDown();
                  } else {
                    _course = courseName;
                    clearDropDown();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 211, 255, 153),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
                  Obx(
                    () => DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width * 0.44,
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Color.fromARGB(255, 211, 255, 153),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      initialSelection:
                          _useCourseDropDown ? null : "New Course",
                      hintText: "Course",
                      onSelected: (scheduleUrl) {
                        _courseTextFieldController.clear();
                        activateDropDown();
                        _scheduleUrl = scheduleUrl!;
                      },
                      dropdownMenuEntries: _useCourseDropDown
                          ? controller.courses.map(
                              (course) {
                                return DropdownMenuEntry<String>(
                                  value: course.schedulesUrl,
                                  label: course.name,
                                  labelWidget: Text(
                                    course.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ).toList()
                          : controller.courses.map(
                              (course) {
                                return DropdownMenuEntry<String>(
                                  value: course.schedulesUrl,
                                  label: course.name,
                                  labelWidget: Text(
                                    course.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ).toList()
                        ..add(
                          const DropdownMenuEntry(
                            value: "New Course",
                            label: "New Course",
                          ),
                        ),
                    ),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 211, 255, 153),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: submit,
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
