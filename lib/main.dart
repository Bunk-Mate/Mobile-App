import 'package:attendence1/pages/onboarding.dart';
import 'package:attendence1/pages/signin.dart';
import 'package:attendence1/pages/navigator.dart';
import 'package:flutter/material.dart';
import 'package:attendence1/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isLogged = await storage.containsKey(key: 'token');
  runApp(
    ProviderScope(child: MyApp(initialRoute: isLogged ? "/mainPage" : "/"))
  );
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
          seedColor: const Color.fromARGB(255, 211, 255, 153),
        ),
        useMaterial3: true,
      ),
      navigatorObservers: [ObserverUtils.routeObserver],
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/mainPage': (context) => const Navigation()
        ,
        '/TimeTable': (context) => const OnBoard()
      },
    );
  }
}
