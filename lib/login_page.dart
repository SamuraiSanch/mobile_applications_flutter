import 'package:flutter/material.dart';
import 'package:flutter_labs/custom_text_field.dart';
import 'package:flutter_labs/user_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepositoryImpl userRepository = UserRepositoryImpl(); // Об'єкт

  LoginPage({super.key});

  // Оновлена функція логіну з перевіркою інтернет-з'єднання
  Future<void> loginUser(BuildContext context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // Показуємо діалогове вікно при відсутності інтернету
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: const Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
     
      final email = emailController.text;
      final password = passwordController.text;

      // Перевірка користувача
      final user = await userRepository.loginUser(email, password);

      if (user != null) {
        // Зберігаємо сесію
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('hasLoggedIn', true);
        
        // Якщо користувач знайдений - рухаємось далі
        Navigator.pushNamed(context, '/profile');
      } else {
        // Якщо дані неправильні — помилка
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Error', style: TextStyle(color: Colors.white)),
            content: Text('Incorrect email or password', style: TextStyle(color: Colors.white)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: 'Email',
              controller: emailController, 
            ),
            CustomTextField(
              labelText: 'Password',
              isPassword: true,
              controller: passwordController, 
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                loginUser(context); 
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
