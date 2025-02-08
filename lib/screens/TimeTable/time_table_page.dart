import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bunk_mate/controllers/timetable/time_table_controller.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage ({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
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

  late final RxString _scheduleUrl = ''.obs;
  late int _day;
  late String _course = "Course";
  bool _useCourseDropDown = true;
  final TextEditingController _courseTextFieldController =
      TextEditingController();

  static const Color bgColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFF4CAF50);
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    controller.getSchedule();
    controller.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      title: Text(
        'My Timetable',
        style: GoogleFonts.lexend(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: Future.wait([controller.getSchedule(), controller.getCourses()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: accentColor));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: textColor)),
          );
        }

        return Obx(() {
          if (controller.schedule.isEmpty) {
            return Center(
              child: Text(
                '📝 Set Up Your Timetable!\n\n'
                'Start by adding a course. Once you’ve done that:\n\n'
                '🔄 Exit and reopen the app to assign it to a specific day.\n\n'
                '💡 Feel free to use the text box below for any extra courses you’d like to add!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.schedule.length,
            itemBuilder: (context, index) {
              final schedule = controller.schedule[index];
              return _buildDayCard(schedule);
            },
          );
        });
      },
    );
  }

  Widget _buildDayCard(dynamic schedule) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.dayOfWeek.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: accentColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...schedule.courses.map((course) => _buildCourseItem(course)),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseItem(dynamic course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(

        children: [
          Icon(getRandomSubjectIcon(), size: 28, color: accentColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
              ],
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
      Icons.history_edu,
      Icons.computer,
      Icons.music_note,
      Icons.palette,
      Icons.sports_basketball
    ];
    return icons[DateTime.now().microsecond % icons.length];
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _showAddCourseBottomSheet(context),
      backgroundColor: accentColor,
      icon: const Icon(Icons.add, color: bgColor),
      label: Text(
        'Add Course',
        style: GoogleFonts.poppins(color: bgColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAddCourseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
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
            const SizedBox(height: 20),
            _buildTextField(
              controller: _courseTextFieldController,
              hintText: 'Enter your Subject Name',
              prefixIcon: Icons.book,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildDayDropdown()),
                const SizedBox(width: 10),
                Expanded(child: _buildCourseDropdown()),
              ],
            ),
            const SizedBox(height: 30),
            Center(child: _buildSubmitButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      onChanged: (courseName) {
        setState(() {
          _course = courseName.isEmpty ? "Course" : courseName;
          _useCourseDropDown = courseName.isEmpty;
        });
      },
      style: const TextStyle(color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: secondaryTextColor),
        prefixIcon: Icon(prefixIcon, color: accentColor),
      ),
    );
  }

  Widget _buildDayDropdown() {
    return DropdownButtonFormField<int>(
      decoration: _getDropdownDecoration(
        prefixIcon: Icons.calendar_today),
      dropdownColor: cardColor,
      hint: Text('Day' ,style: TextStyle(color: secondaryTextColor)),
      style: const TextStyle(color: textColor),
      onChanged: (day) => _day = day!,
      items: days.entries.map((day) {
        return DropdownMenuItem<int>(
          value: day.key,
          child: Text(day.value),
        );
      }).toList(),
    );
  }

  Widget _buildCourseDropdown() {
    return Obx(() {
      if (controller.courses.isEmpty) {
        return DropdownButtonFormField<String>(
          decoration: _getDropdownDecoration(
               prefixIcon: Icons.school),
          hint: Text("No courses available",style: TextStyle(color: secondaryTextColor)),
          dropdownColor: cardColor,
          style: const TextStyle(color: textColor),
          value: null,
          items: [],
          onChanged: null,
        );
      }

      return DropdownButtonFormField<String>(
        decoration: _getDropdownDecoration(
            prefixIcon: Icons.school),
        dropdownColor: cardColor,
        hint: Text("Course" , style: TextStyle(color: secondaryTextColor),),
        style: const TextStyle(color: textColor),
        value: _useCourseDropDown ? null : "New Course",
        onChanged: (scheduleUrl) {
          _courseTextFieldController.clear();
          setState(() {
            _useCourseDropDown = true;
            _scheduleUrl.value = scheduleUrl!;
          });
        },
        items: [
          ...controller.courses.map((course) => DropdownMenuItem<String>(
                value: course.schedulesUrl,
                child: Text(course.name, overflow: TextOverflow.ellipsis),
              )),
          const DropdownMenuItem<String>(
            value: "New Course",
            child: Text("New Course"),
          ),
        ],
      );
    });
  }

  InputDecoration _getDropdownDecoration(
      { required IconData prefixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(prefixIcon, color: accentColor),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: _submitForm,
      child: Text(
        "Add Course",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  void _submitForm() {
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
    Get.snackbar("Success", "Course added! Refresh to see changes.",
        backgroundColor: cardColor, colorText: textColor);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _courseTextFieldController.dispose();
    super.dispose();
  }
}
