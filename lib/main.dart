import 'package:flutter/material.dart';
import 'package:flutter_labs/login_page.dart';
import 'package:flutter_labs/main_page.dart';
import 'package:flutter_labs/profile_page.dart';
import 'package:flutter_labs/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Labs',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 33, 33, 33),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Базовий текст білий
          titleMedium: TextStyle(color: Colors.white), // Для заголовків
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),//Білий колір для txt полів
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 20, 153, 242)),
          ),
          hintStyle: TextStyle(color: Colors.white70),//Підказки будуть білуваті
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}
