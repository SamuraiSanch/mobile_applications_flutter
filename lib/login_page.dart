import 'package:flutter/material.dart';
import 'package:flutter_labs/custom_text_field.dart';
import 'package:flutter_labs/user_repository_impl.dart'; 

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepositoryImpl userRepository = UserRepositoryImpl(); // Об'єкт

  LoginPage({super.key});

  Future<void> loginUser(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    // Перевірка користувача
    final user = await userRepository.loginUser(email, password);

    if (user != null) {
      // Якщо користувач знайдений - рухаємось далі
      Navigator.pushNamed(context, '/profile');
    } else {
      // Якщо дані неправильні — помилка
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            backgroundColor: Colors.black, 
            title: Text(
              'Login failed',
              style: TextStyle(color: Colors.white), 
            ),
            content: Text(
              'Invalid email or password.',
              style: TextStyle(color: Colors.white), 
    ),
  ),
);

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
              controller: emailController, // Передаємо контролер
            ),
            CustomTextField(
              labelText: 'Password',
              isPassword: true,
              controller: passwordController, // Передаємо контролер
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
                loginUser(context); // Викликаємо логіку логіну
              },
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
