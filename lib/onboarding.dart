import 'package:attendence1/login.dart';
import 'package:attendence1/subject.dart';
import 'package:attendence1/timetablefinal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:date_field/date_field.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const OnBoard());
}

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      body: Column(
        children: [
          Container(
              color: Color.fromARGB(255, 13, 15, 21),
              width: 500,
              height: 300,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    SafeArea(
                        child: Center(
                      child: Text("Welcome to the Attendance Tracker",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontFamily: 'alpha')),
                    )),
                  ],
                ),
              )),
          Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'TimeTable Name',
                        hintStyle: TextStyle(color: Colors.white24),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27)),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    initialValue: "75",
                    style: TextStyle(color: Colors.white24),
                    decoration: const InputDecoration(
                        hintText: 'Minimum Attendence',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Color.fromARGB(255, 17, 20, 27)),
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      labelText: 'Enter Date',
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    lastDate: DateTime.now().add(const Duration(days: 40)),
                    initialPickerDateTime:
                        DateTime.now().add(const Duration(days: 20)),
                    onChanged: (DateTime? value) {
                      var startDate = value;
                    },
                  ),
                  SizedBox(
                    width: 25,
                    height: 25,
                  ),
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      labelText: 'Enter Date',
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    lastDate: DateTime.now().add(const Duration(days: 40)),
                    initialPickerDateTime:
                        DateTime.now().add(const Duration(days: 20)),
                    onChanged: (DateTime? value) {
                      var endDate = value;
                    },
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimeTable()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                              child: Text(
                            "NEXT",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )),
                          width: 405,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}
