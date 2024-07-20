import 'package:bunk_mate/screens/OnBoardView.dart';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/utils/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bunk_mate/controllers/homepage/course_summary_controller.dart';
import 'package:bunk_mate/controllers/auth/login_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  final CourseSummaryController courseSummaryController =
      Get.put(CourseSummaryController());
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
    courseSummaryController.fetchCourseSummary();
  }

  @override
  Widget build(BuildContext context) {
    courseSummaryController.fetchCourseSummary();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 9, 15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
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
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/pp.png'),
                    ),
                    onDoubleTap: () async {
                      bool success = await loginController.logoutfunction();
                      if (success == false) {
                        Get.off(const AuthScreen());
                        Get.snackbar("Logout Succesfull",
                            "You were logged out succesfully");
                        Get.deleteAll();
                      } else {
                        Get.snackbar(
                            "Error", "You Weren't Logged Out Try Again");
                        Get.to(Navigation());
                      }
                    },
                  ),
                ),
                Expanded(child: Container()),
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Color.fromARGB(255, 232, 252, 116),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Update Timetable",
                            style: TextStyle(
                                color: Color.fromARGB(255, 232, 252, 116)),
                          ),
                        ],
                      ),
                    ),
                    // PopupMenuItem 2
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 232, 252, 116),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Color.fromARGB(255, 232, 252, 116),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  offset: Offset(0, 111),
                  color: Color.fromARGB(255, 7, 9, 15),
                  elevation: 2,
                  onSelected: (value) async {
                    if (value == 1) {
                      Get.to(TimetableView());
                    } else if (value == 2) {
                      bool success = await loginController.logoutfunction();
                      if (success == false) {
                        Get.off(const AuthScreen());
                        Get.snackbar("Logout Succesfull",
                            "You were logged out succesfully");
                        Get.deleteAll();
                      } else {
                        Get.snackbar(
                            "Error", "You Weren't Logged Out Try Again");
                        Get.to(Navigation());
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Obx(() {
            if (courseSummaryController.courseSummary.isEmpty) {
              Future.delayed(Duration(seconds: 20), () {
                courseSummaryController.fetchCourseSummary();
              });
              return const Center(
                child: Text(
                  "📚 No Course Available\n📝 Please add a course!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0, 
                  ),
                ),
              );
            }
            List<_ChartData> data = courseSummaryController.courseSummary
                .map((subject) =>
                    _ChartData(subject.name, subject.percentage.toDouble()))
                .toList();
            return ListView(
              children: [
                // Chart Widget
                Center(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 100,
                      interval: 10,
                      majorGridLines: const MajorGridLines(width: 0),
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.lexend().fontFamily,
                      ),
                    ),
                    tooltipBehavior: _tooltip,
                    series: <CartesianSeries<_ChartData, String>>[
                      BarSeries<_ChartData, String>(
                        gradient: const LinearGradient(
                          colors: <Color>[
                            Color.fromARGB(255, 192, 252, 96),
                            Color.fromARGB(255, 212, 252, 96),
                            Color.fromARGB(255, 232, 252, 116),
                            Color.fromARGB(255, 252, 252, 136),
                            Color.fromARGB(255, 252, 252, 188),
                          ],
                          stops: <double>[0.1, 0.3, 0.5, 0.7, 0.9],
                          // Setting alignment for the series gradient
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: 'Attendance Summary',
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          labelAlignment: ChartDataLabelAlignment.middle,
                        ),
                      )
                    ],
                  ),
                ),

                // Course Summary List
                ...courseSummaryController.courseSummary.map((subject) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.abc,
                          size: 62,
                          color: Colors.white,
                        ),
                        title: Text(
                          subject.name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Attendance: ${subject.percentage}%",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: SafeArea(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color.fromARGB(255, 211, 255, 153),
                            child: Text(
                              subject.bunksAvailable.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
