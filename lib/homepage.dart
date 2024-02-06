import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

List<IconData> subjectIcons = [
  Icons.school,
  Icons.book,
  Icons.star,
  Icons.people,
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyWidget(),
    );
  }
}

class Subject {
  final String name;
  final int attendance;
  final int bunks;

  Subject({
    required this.name,
    required this.attendance,
    required this.bunks,
  });
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final List<Subject> subjects = [
    Subject(name: 'English', attendance: 76, bunks: 1),
    Subject(name: 'Maths', attendance: 88, bunks: 0),
    Subject(name: 'Science', attendance: 92, bunks: 0),
    Subject(name: 'History', attendance: 68, bunks: 2),
    Subject(name: 'History', attendance: 68, bunks: 2),
    Subject(name: 'History', attendance: 68, bunks: 2),
    Subject(name: 'Maths ', attendance: 68, bunks: 2),
    Subject(name: 'History', attendance: 68, bunks: 2),
    Subject(name: 'History', attendance: 68, bunks: 2),
    Subject(name: 'History', attendance: 68, bunks: 2),
  ];

  @override
  Widget build(BuildContext context) {
    IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: AppBar(
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Good Morning,",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'alpha',
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  "Abhinav Saxena",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'alpha',
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 7, 9, 15),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: CircleAvatar(
            radius: 30.0,
            backgroundImage: const NetworkImage(''),
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt4ReEt7nQu7E_T_oQYM9YqImOK4Fkbc8Tfw&usqp=CAU',
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: subjects
                          .asMap()
                          .map((index, subject) => MapEntry(
                              index.toDouble(),
                              FlSpot(index.toDouble(),
                                  subject.attendance.toDouble())))
                          .values
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return ListTile(
                    leading: Icon(
                      getRandomSubjectIcon(),
                      size: 62,
                      color: Colors.white,
                    ),
                    title: Text(
                      subject.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Attendance: ${subject.attendance}%   Bunks: ${subject.bunks}",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
