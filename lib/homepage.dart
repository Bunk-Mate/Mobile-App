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
    "Hello",            // English
    "Hola",             // Spanish
    "Bonjour",          // French
    "Ciao",             // Italian
    "Hallo",            // German
    "Olá",              // Portuguese
    "你好",               // Chinese (Simplified)
    "こんにちは",           // Japanese
    "नमस्ते",              // Hindi
    "여보세요",              // Korean
    "Merhaba",          // Turkish
    "Привет",           // Russian
    "مرحبا",             // Arabic
    "Hej",              // Swedish
    "Aloha",            // Hawaiian
    "Hallå",            // Swedish
    "Halo",             // Indonesian
    "Sawubona",         // Zulu
    "Hei",              // Finnish
    "Բարև",              // Armenian
    "გამარჯობა",          // Georgian
    "Salut",            // Romanian
    "Hei",              // Norwegian
    "नमस्कार",            // Nepali
    "Ողջույն",            // Armenian
    "សួស្តី",              // Khmer
    "Hej",              // Danish
    "Szia",             // Hungarian
    "ഹലോ",              // Malayalam
    "Прывітанне",          // Belarusian
    "ਸਤ ਸ੍ਰੀ ਅਕਾਲ",         // Punjabi
    "வணக்கம்",             // Tamil
    "Xin chào",          // Vietnamese
    "Привіт",            // Ukrainian
    "مرحبا",             // Urdu
    "হ্যালো",              // Bengali
    "ಹಲೋ",                // Kannada
    "Բարև",               // Armenian
    "नमस्कार",             // Marathi
    "Բարև",               // Armenian
    "ສະບາຍດີ",            // Lao
    "မင်္ဂလာပါ",          // Burmese
    "բարև",               // Armenian
    "Բարև",               // Armenian
    "بەخێربێیت",            // Kurdish
    "Салам",             // Tajik
    "ನಮಸ್ಕಾರ",             // Kannada
    "سلام",               // Kurdish
    "Բարև",               // Armenian
    "բարև",               // Armenian
    "سلام"                // Pashto
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
    print(
        "= = = === === = ==  STATISTICS HAVE BEEN UPDATED! =  ===== = == == == ");
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
    String getRandomHello() {
      var randomIndex = Random().nextInt(Hello.length);
      return Hello[randomIndex];
    }

    return Container(
      child: Scaffold(
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
                  // Text(
                  //   "Good Morning,",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'alpha',
                  //     fontWeight: FontWeight.w200,
                  //   ),
                  // ),
                  Container(
     
                    child: Text(
                      getRandomHello(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'alpha',
                      ),
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
                        width: MediaQuery.of(context).size.width * 0.3,
                        sheetColor: Color.fromARGB(255, 7, 9, 15),
                        body: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                            ),
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => Navigator.pop(
                                    context, 'Data Returns Left')),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        Color.fromARGB(255, 211, 255, 153))),
                                onPressed: () {
                                  logout();
                                  Navigator.pushNamed(context, '/');
                                },
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: Colors.black),
                                ))
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row(
              //   children: [

              //     // Padding(
              //     //   padding: const EdgeInsets.all(15),
              //     //   child: SizedBox (width: 350,height: 250, child:SfCartesianChart(
              //     //     primaryXAxis: CategoryAxis(),
              //     //     series: <BarSeries<AttendenceData, String>>[
              //     //       BarSeries<AttendenceData, String>(
              //     //         dataSource: attendanceData,
              //     //         xValueMapper: (AttendenceData attendenceData, _) => attendenceData.subject,
              //     //         yValueMapper: (AttendenceData attendenceData, _) => attendenceData.percentage,
              //     //          width: 0.6,
              //     //                       // Spacing between the bars
              //     //                       spacing: 0.3 ,
              //     //                       color: Color.fromARGB(255, 211, 255, 153),
              //     //       )
              //     //     ],
              //     //   ),
              //     // )),
              //   ],
              // ),
              // SizedBox(height:  MediaQuery.of(context).size.width *  0.3),
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
      ),
    );
  }
}

class AttendenceData {
  AttendenceData(this.percentage, this.subject);
  final String subject;
  final double percentage;
}
