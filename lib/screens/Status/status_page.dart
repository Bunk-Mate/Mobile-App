import 'package:bunk_mate/controllers/status/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatusView extends StatelessWidget {
  final StatusController controller =
      Get.put(StatusController(apiUrl: 'https://api.bunkmate.college'));

  @override
  Widget build(BuildContext context) {
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    controller.getStatus();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight / 14),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 192, 252, 96),
                Color.fromARGB(255, 212, 252, 96),
                Color.fromARGB(255, 232, 252, 116),
                Color.fromARGB(255, 252, 252, 136),
                Color.fromARGB(255, 252, 252, 188),
              ],
            ),
          ),
          child: AppBar(
            toolbarHeight: screenHeight / 16,
            actions: [
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth / 30),
                        child: Obx(
                          () => Text(
                            controller
                                .days[controller.selectedDate.value.weekday]
                                .toString(),
                            style: GoogleFonts.lexend(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth / 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth / 6),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 211, 255, 153),
                            ),
                          ),
                          onPressed: () => controller.selectDate(context),
                          child: Text(
                            "REWIND TIME",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Obx(
        () => controller.courses.isNotEmpty
            ? ListView.builder(
                itemCount: controller.courses.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = controller.courses[index]["name"].toString();
                  String status = controller.courses[index]["status"];
                  Color statusColor;

                  switch (status) {
                    case 'bunked':
                      statusColor = Colors.red;
                      break;
                    case 'cancelled':
                      statusColor = Colors.blue.shade700;
                      break;
                    default:
                      statusColor = Colors.green;
                      break;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.courses[index]["status"] = "bunked";
                        controller.updateStatus(
                          controller.courses[index]["session_url"],
                          "bunked",
                          date: controller.selectedDate.value,
                        );
                      },
                      onDoubleTap: () {
                        controller.courses[index]["status"] = "cancelled";
                        controller.updateStatus(
                          controller.courses[index]["session_url"],
                          "cancelled",
                          date: controller.selectedDate.value,
                        );
                      },
                      onLongPress: () {
                        controller.courses[index]["status"] = "Present";
                        controller.updateStatus(
                          controller.courses[index]["session_url"],
                          "present",
                          date: controller.selectedDate.value,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 13, 15, 21),
                        ),
                        child: ListTile(
                          leading: Icon(
                            controller.getRandomSubjectIcon(),
                            size: screenWidth / 10,
                            color: Colors.white,
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 22,
                            ),
                          ),
                          trailing: Container(
                            width: screenWidth / 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Courses Scheduled Today!",
                      style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 20,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 30),
                    SizedBox(
                      width: screenWidth / 2,
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          fillColor: Color.fromARGB(255, 211, 255, 153),
                          filled: true,
                        ),
                        hint: Text("Copy Schedule"),
                        items: controller.days.entries.map((days) {
                          return DropdownMenuItem<int>(
                            value: days.key,
                            child: Text(days.value),
                          );
                        }).toList(),
                        onChanged: (days) {
                          if (days != null) {
                            controller.addHoliday(days);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
