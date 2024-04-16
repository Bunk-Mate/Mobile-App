import 'dart:convert';
import 'dart:io';
import 'package:attendence1/global.dart';
import 'package:attendence1/pages/onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:attendence1/utls/HomePage.dart' ;
import 'package:attendence1/utls/imp.dart';
import 'package:side_sheet/side_sheet.dart';
class HomePage extends StatefulWidget {
  const HomePage({required Key key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  final storage = const FlutterSecureStorage();
  Future<String> getToken() async {
    dynamic token = await storage.read(key: 'token');
    print(token);
    return token;
  }
  late dynamic stats = [];
  Future<dynamic> getStats() async {
    final response = await http.get(
      Uri.parse('$apiUrl/statquery'),
      headers: {
        HttpHeaders.authorizationHeader: "Token ${await getToken()}",
      },
    );
    if (response.statusCode == 200) {
      print("Bye");
      setState(() {
        stats = jsonDecode(response.body);
        print(response.body);
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 9, 15),
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
                  style: const TextStyle(
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
      sheetColor: const Color.fromARGB(255, 7, 9, 15),
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
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 211, 255, 153),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const OnBoard(),
                  ));
                },
                child: const Text(
                  "Timetable",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 211, 255, 153),
                  ),
                ),
                onPressed: () {
                logout();
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 211, 255, 153),
              ),
              onPressed: () => Navigator.pop(context, 'Data Returns Left'),
            ),
          ),
        ],
      ),
      context: context,
    );    
                },
                child: ClipOval(
                  child: Icon(Icons.menu,size: 30,color: Colors.white,)
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
                    Expanded(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color.fromARGB(255, 211, 255, 153),
                            child: Text(
                              "${subject["bunks_available"]}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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