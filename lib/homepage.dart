import 'dart:convert';
import 'dart:io';

import 'package:attendence1/global.dart';
import 'package:attendence1/onboarding.dart';
import 'package:attendence1/subject.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

List<String> Hello = [
  "Hello", // English
  "Hola", // Spanish
  "Bonjour", // French
  "Ciao", // Italian
  "Hallo", // German
  "Olá", // Portuguese
  "你好", // Chinese (Simplified)
  "こんにちは", // Japanese
  "नमस्ते", // Hindi
  "여보세요", // Korean
  "Merhaba", // Turkish
  "Привет", // Russian
  "مرحبا", // Arabic
  "Hej", // Swedish
  "Aloha", // Hawaiian
  "Hallå", // Swedish
  "Halo", // Indonesian
  "Sawubona", // Zulu
  "Hei", // Finnish
  "Բարև", // Armenian
  "გამარჯობა", // Georgian
  "Salut", // Romanian
  "Hei", // Norwegian
  "नमस्कार", // Nepali
  "Ողջույն", // Armenian
  "សួស្តី", // Khmer
  "Hej", // Danish
  "Szia", // Hungarian
  "ഹലോ", // Malayalam
  "Прывітанне", // Belarusian
  "ਸਤ ਸ੍ਰੀ ਅਕਾਲ", // Punjabi
  "வணக்கம்", // Tamil
  "Xin chào", // Vietnamese
  "Привіт", // Ukrainian
  "مرحبا", // Urdu
  "হ্যালো", // Bengali
  "ಹಲೋ", // Kannada
  "Բարև", // Armenian
  "नमस्कार", // Marathi
  "Բարև", // Armenian
  "ສະບາຍດີ", // Lao
  "မင်္ဂလာပါ", // Burmese
  "բարև", // Armenian
  "Բարև", // Armenian
  "بەخێربێیت", // Kurdish
  "Салам", // Tajik
  "ನಮಸ್ಕಾರ", // Kannada
  "سلام", // Kurdish
  "Բարև", // Armenian
  "բարև", // Armenian
  "سلام" // Pashto
];

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
  MyWidget({required Key key}) : super(key: key);

  @override
  State<MyWidget> createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

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
      statsUpdate = false;
    }
    // Collection does not exist
    else if (response.statusCode == 404) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const OnBoard()));
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
      await storage.delete(key: 'token');
      Navigator.pushNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logged out successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to log out"),
        ),
      );
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

    String getRandomHello() {
      var randomIndex = Random().nextInt(Hello.length);
      return Hello[randomIndex];
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
                  getRandomHello(),
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
                onTap: () async {
                  final data = await SideSheet.left(
                      width: MediaQuery.of(context).size.width * 0.4,
                      sheetColor: Color.fromARGB(255, 7, 9, 15),
                      body: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.25,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 211, 255, 153),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OnBoard()));
                                },
                                child: Text(
                                  "Timetable",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromARGB(255, 211, 255, 153),
                                  ),
                                ),
                                onPressed: () {
                                  logout();
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: IconButton(
                                icon: Icon(Icons.close,
                                    color: Color.fromARGB(255, 211, 255, 153)),
                                onPressed: () => Navigator.pop(
                                    context, 'Data Returns Left')),
                          ),
                        ],
                      ),
                      context: context);

                  print(data);
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: ListView.builder(
              itemCount: stats.length,
              itemBuilder: (context, index) {
                final subject = stats[index];
                return Column(
                  children: [
                    ListTile(
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
                          "Attendance: ${subject["percentage"]}%",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        trailing: Expanded(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color.fromARGB(255, 211, 255, 153),
                            child: Text(
                              "${subject["bunks_available"]}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class AttendenceData {
  AttendenceData(this.percentage, this.subject);
  final String subject;
  final double percentage;
}
