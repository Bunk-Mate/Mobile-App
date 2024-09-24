import 'package:bunk_mate/screens/OnBoardView.dart';
import 'package:bunk_mate/screens/TimeTable/time_table_page.dart';
import 'package:bunk_mate/screens/auth/login_screen.dart';
import 'package:bunk_mate/screens/homepage/homepage_screen.dart';
import 'package:bunk_mate/utils/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();
 WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(
      future: storage.read(key: 'token'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.greenAccent),
                useMaterial3: true,
              ),
              home: const Navigation(),
            );
          } else {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                fontFamily: GoogleFonts.lexend().fontFamily,
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.greenAccent),
                useMaterial3: true,
              ),
              home: const AuthScreen(),
            );
          }
        }
      },
    );
  }
}
