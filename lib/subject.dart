import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:attendence1/global.dart';
import 'package:attendence1/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

List<IconData> subjectIcons = [
  Icons.school,
  Icons.book,
  Icons.star,
  Icons.people,
  Icons.abc,
  Icons.laptop_chromebook_outlined,
  Icons.macro_off,
  Icons.work,
  Icons.home,
  Icons.music_note,
  Icons.sports_soccer,
  Icons.local_movies,
  Icons.restaurant,
  Icons.directions_run,
  Icons.build,
  Icons.airplanemode_active,
  Icons.beach_access,
  Icons.shopping_cart,
  Icons.local_hospital,
  Icons.local_florist,
  Icons.brush,
  Icons.business_center,
  Icons.cake,
  Icons.camera,
  Icons.train,
  Icons.phone,
  Icons.pets,
  Icons.local_pizza,
  Icons.wifi,
  Icons.palette,
  Icons.play_circle_filled,
  Icons.favorite,
  Icons.radio,
  Icons.beenhere,
  Icons.casino,
  Icons.child_friendly,
  Icons.create,
  Icons.desktop_windows,
  Icons.directions_bike,
  Icons.emoji_food_beverage,
  Icons.flash_on,
  Icons.golf_course,
  Icons.pool,
  Icons.shopping_basket,
  Icons.star_border,
  Icons.videogame_asset,
  Icons.local_laundry_service,
  Icons.toys,
  Icons.watch,
  Icons.local_dining,
];


Future<void> getStatus() async {
  final state = TimeTableState();
  await state.getStatus();
}

class TimeTable extends StatefulWidget {
  TimeTable({required Key key}) : super(key: key);
  @override
  State<TimeTable> createState() => TimeTableState();
}

class TimeTableState extends State<TimeTable> with RouteAware {
  late dynamic courses = [];
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }

  Future<dynamic> getStatus() async {
    DateTime now = new DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);

    //TEMP
    today = DateFormat("yyyy-MM-dd").format(DateTime(2024, 2, 5));

    final response = await http.get(
      Uri.parse(apiUrl + '/datequery?date=$today'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
        HttpHeaders.contentTypeHeader: "application/json"
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        courses = jsonDecode(response.body);
      });
      statusUpdate = false;
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
      // Signal the statistics page to update on navigation
      statsUpdate = true;
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to update status');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    IconData getRandomSubjectIcon() {
      var randomIndex = Random().nextInt(subjectIcons.length);
      return subjectIcons[randomIndex];
    }
    final currentDay = DateFormat('EEEE').format(DateTime.now());
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 9, 15),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            String name = courses[index]["name"].toString().toCapitalized();
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
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color.fromARGB(255, 13, 15, 21)),
                        
                        child: ListTile(
                          leading: Icon(getRandomSubjectIcon(),size: 32,),
                          iconColor: Colors.white,
                        
                          title: Text(
                            "$name",
                            style: TextStyle(color: Colors.white, fontSize: 32),
                          ),
                          trailing: Text(
                            "$status",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    )),
               SizedBox(width: 10,height: 10,)
                
              ],
            );
          }),
    );
  }
}
