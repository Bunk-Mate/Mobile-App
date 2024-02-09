import 'dart:convert';
import 'dart:io';

import 'package:attendence1/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;

class TimeTable extends StatefulWidget {
  const TimeTable({super.key});

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ObserverUtils.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    ObserverUtils.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    super.didPush();
    getStatus();
  }

  late dynamic courses = [];
  final storage = FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  Future<dynamic> getStatus() async {
    DateTime now = new DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    final response = await http.get(
      Uri.parse(apiUrl + '/datequery?date=$today'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        courses = jsonDecode(response.body);
      });
      print(courses);
    } else {
      print(response.body);
      throw Exception('Failed to retrieve status');
    }
  }

  Future<dynamic> updateStatus(String url, String status) async {
    final response = await http.patch(
      Uri.parse(url),
      //http://8204-2401-4900-32f5-8fbf-3bb0-90ee-d369-d2bb.ngrok-free.app/session/32498
       body: jsonEncode({"status": status}),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    if (response.statusCode == 200) {
      getStatus();
      print(status);
    } else {
      print(response.body);
      print(response.statusCode);
      print(url);
      throw Exception('Failed to update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: AppBar(
        title: Text(
          currentDay,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        backgroundColor: Color.fromARGB(255, 7, 9, 15),
      ),
      body: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (BuildContext context, int index) {
            String name = courses[index]["name"];
            String status = courses[index]["status"];
            return new Column(
              children: [
                GestureDetector(
                    onTap: () {
                      updateStatus(courses[index]["session_url"], "bunked");
                    },
                    onDoubleTap: () {
                      updateStatus(courses[index]["session_url"], "cancelled");
                    },
                    onLongPress: () {
                      //courses[index]["status"] = "Present";
                      updateStatus(courses[index]["session_url"], "present");
                    },
                    child: ListTile(
                      title: Text(
                        "$name",
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      ),
                      trailing: Text(
                        "$status",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                new Divider(
                  height: 2.0,
                )
              ],
            );
          }),
    );
  }
}
