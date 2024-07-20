import 'package:bunk_mate/controllers/status/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StatusView extends StatelessWidget {
  final StatusController controller = Get.put(StatusController(apiUrl: 'https://api.bunkmate.college'));

  @override
  Widget build(BuildContext context) {
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    controller.getStatus();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 14),
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
            toolbarHeight: MediaQuery.of(context).size.height / 12,
            actions: [
              Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
                          child: Obx(() => Text(
                            controller.days[controller.selectedDate.value.weekday].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              fontFamily: GoogleFonts.lexend().fontFamily),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 4),
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
                  Divider(color: Colors.white)
                ],
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Obx(() => controller.courses.isNotEmpty
          ? ListView.builder(
              itemCount: controller.courses.length,
              itemBuilder: (BuildContext context, int index) {
                String name = controller.courses[index]["name"].toString();
                String status = controller.courses[index]["status"];
                Color c1;
                if (status == 'bunked') {
                  c1 = Colors.red;
                } else if (status == 'cancelled') {
                  c1 = Colors.blue.shade700;
                } else {
                  c1 = Colors.green;
                }
                return Column(
                  children: [
                    GestureDetector(
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 13, 15, 21),
                          ),
                          child: ListTile(
                            leading: Icon(
                              controller.getRandomSubjectIcon(),
                              size: 32,
                            ),
                            iconColor: Colors.white,
                            title: Text(
                              "$name",
                              style: TextStyle(color: Colors.white, fontSize: 32),
                            ),
                            trailing: Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c1,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "$status",
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10, height: 10),
                  ],
                );
              })
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Courses Scheduled Today!",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'alpha',
                      fontSize: MediaQuery.of(context).size.width / 17,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(width: 30, height: 30),
                  DropdownMenu(
                    width: MediaQuery.of(context).size.width / 2,
                    hintText: "Copy Schedule",
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: const Color.fromARGB(255, 211, 255, 153),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    dropdownMenuEntries: controller.days.entries.map((days) {
                      return DropdownMenuEntry<int>(
                        value: days.key,
                        label: days.value,
                      );
                    }).toList(),
                    onSelected: (days) {
                      controller.addHoliday(days!);
                    },
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
