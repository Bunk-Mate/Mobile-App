import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class beta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: india(),
    );
  }
}
class india extends StatefulWidget {
  const india({super.key});

  @override
  State<india> createState() => _TimeTableState();
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
List<IconData> subjectIcons = [
  Icons.school,
  Icons.book,
  Icons.star,
  Icons.people,
];
class _TimeTableState extends State<india> {
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  late dynamic stats = [];
  

  Future<dynamic> getStats() async {
    final response = await http.get(
      Uri.parse(apiUrl + '/datequery'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        stats = jsonDecode(response.body);
      });
      print(stats);
    } else {
      throw Exception('Failed to retrieve statistics');
    }
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }
  IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }
  final List<Subject> monday = [
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
  final List<Subject> tuesday = [
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
  final List<Subject> wednesday = [
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
  final List<Subject> thursday = [
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
  final List<Subject> friday = [
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
  final List<Subject> Saturday = [
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
  final List<Subject> Sunday = [
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
    return PageView(
      children: [
        Expanded(
              child: ListView.builder(
                itemCount: monday.length,
                itemBuilder: (context, index) {
                  final subject = monday[index];
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
    );
  }
}