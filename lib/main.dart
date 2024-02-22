import 'package:attendence1/TimeTableEntry.dart';
import 'package:attendence1/homepage.dart';
import 'package:attendence1/login.dart';
import 'package:attendence1/navigator.dart';
import 'package:attendence1/onboarding.dart';
import 'package:attendence1/signup.dart';
import 'package:attendence1/subject.dart';
import 'package:attendence1/timetable.dart';
import 'package:flutter/material.dart';
import 'package:attendence1/global.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLogged = await storage.containsKey(key: 'token');
  runApp(MyApp(initialRoute: isLogged ? "/mainPage" : "/"));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({required this.initialRoute, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'alpha',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 211, 255, 153),
        ),
        useMaterial3: true,
      ),
      navigatorObservers: [ObserverUtils.routeObserver],
      initialRoute: initialRoute,
      routes: {
        '/': (context) => LoginPage(),
        '/mainPage': (context) => Navigation()
      },
    );
  }
}
