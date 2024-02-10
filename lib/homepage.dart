import 'dart:convert';
import 'dart:io';

import 'package:attendence1/global.dart';
import 'package:attendence1/subject.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_icons/line_icons.dart';

void main() {
  runApp(MyApp());
}
extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _children = <Widget>[
  MyWidget(),
  TimeTable(),
];
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  late dynamic stats = [];

  Future<dynamic> getStats() async {
    final response = await http.get(
      Uri.parse(apiUrl + '/statquery'),
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

  Future<dynamic> logout() async {
    final response = await http.post(
      Uri.parse(apiUrl + '/logout'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      print("It works");
    } else {
      throw Exception('Failed to retrieve statistics');
    }
  }

  @override
  void initState() {
    super.initState();
    getStats();
  }

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
                  "User",
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
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TimeTable()));
                },
                child: ClipOval(
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRt4ReEt7nQu7E_T_oQYM9YqImOK4Fkbc8Tfw&usqp=CAU',
                  ),
                )),
          ),
        ),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text("Logout")),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  final subject = stats[index];

                  return ListTile(
                    leading: Icon(
                      getRandomSubjectIcon(),
                      size: 62,
                      color: Colors.white,
                    ),
                    title: Text(
                      subject["name"].toString().toTitleCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Attendance: ${subject["percentage"]}%   Bunks: ${subject["bunks_available"]}",
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
