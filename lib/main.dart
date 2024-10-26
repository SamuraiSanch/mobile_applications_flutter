import 'package:flutter/material.dart';
import 'package:flutter_labs/login_page.dart';
import 'package:flutter_labs/main_page.dart';
import 'package:flutter_labs/profile_page.dart';
import 'package:flutter_labs/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasLoggedIn = prefs.getBool('hasLoggedIn') ?? false;

  runApp(MyApp(hasLoggedIn: hasLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool hasLoggedIn;

  const MyApp({required this.hasLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: hasLoggedIn ? '/main' : '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/main': (context) => const MainPage(),
        '/profile': (context) => const ProfilePage(),  
        '/register': (context) => const RegisterPage(),  
      },
    );
  }
}
