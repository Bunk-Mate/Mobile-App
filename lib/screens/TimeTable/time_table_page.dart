import 'package:bunk_mate/controllers/timetable/time_table_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  late RxString _scheduleUrl = ''.obs;
  late int _day;
  late String _course = "Course";
  bool _useCourseDropDown = true;
  TextEditingController _courseTextFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getSchedule();
    controller.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(0xFF121212);
    final Color cardColor = Color(0xFF1E1E1E);
    final Color accentColor = Color(0xFF4CAF50);
    final Color textColor = Colors.white;
    final Color secondaryTextColor = Colors.white70;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Timetable',
          style: GoogleFonts.lexend(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _settingModalBottomSheet(context),
        backgroundColor: accentColor,
        child: Icon(Icons.add, color: bgColor),
      ),
      body: FutureBuilder(
        future:
            Future.wait([controller.getSchedule(), controller.getCourses()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: accentColor));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: textColor)));
          }

          return Obx(() {
            return SafeArea(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.schedule.length,
                itemBuilder: (context, index) {
                  final schedule = controller.schedule[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 20),
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              schedule.dayOfWeek.toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: accentColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ...schedule.courses.map(
                              (course) => _buildCourseItem(course, textColor)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCourseItem(dynamic course, Color textColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(getRandomSubjectIcon(), size: 28, color: textColor),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              course.name.toUpperCase(),
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData getRandomSubjectIcon() {
    final icons = [
      Icons.book,
      Icons.science,
      Icons.calculate,
      Icons.language,
      Icons.history_edu
    ];
    return icons[DateTime.now().microsecond % icons.length];
  }

  @override
  void dispose() {
    _courseTextFieldController.dispose();
    super.dispose();
  }

  void _settingModalBottomSheet(BuildContext context) {
    final Color bgColor = Color(0xFF121212);
    final Color cardColor = Color(0xFF1E1E1E);
    final Color accentColor = Color(0xFF4CAF50);
    final Color textColor = Colors.white;

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
        if (_scheduleUrl.value.isEmpty) {
          Get.snackbar("Error", "Please select a course.",
              backgroundColor: cardColor, colorText: textColor);
          return;
        }
        controller.addSchedule(_scheduleUrl.value, _day);
      } else {
        controller.addCourse(_course, _day);
      }
      Navigator.of(context).pop();
    }

    showModalBottomSheet(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add New Course',
              style: GoogleFonts.poppins(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your Subject Name',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.book, color: accentColor),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Day",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon:
                          Icon(Icons.calendar_today, color: accentColor),
                    ),
                    dropdownColor: cardColor,
                    style: TextStyle(color: textColor),
                    onChanged: (day) {
                      _day = day!;
                    },
                    items: days.entries.map(
                      (day) {
                        return DropdownMenuItem<int>(
                          value: day.key,
                          child: Text(day.value),
                        );
                      },
                    ).toList(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Course",
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.school, color: accentColor),
                      ),
                      dropdownColor: cardColor,
                      style: TextStyle(color: textColor),
                      value: _useCourseDropDown ? null : "New Course",
                      onChanged: (scheduleUrl) {
                        _courseTextFieldController.clear();
                        activateDropDown();
                        _scheduleUrl.value = scheduleUrl!;
                      },
                      items: [
                        ...controller.courses.map(
                          (course) => DropdownMenuItem<String>(
                            value: course.schedulesUrl,
                            child: Text(
                              course.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "New Course",
                          child: Text("New Course"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: bgColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: submit,
                child: Text(
                  "Add Course",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
