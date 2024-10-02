import 'package:flutter/material.dart';
import 'package:flutter_labs/custom_text_field.dart';
import 'package:flutter_labs/user_repository.dart'; 
import 'package:flutter_labs/user_repository_impl.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserRepository userRepository = UserRepositoryImpl();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> registerUser() async {
    final email = emailController.text;
    final password = passwordController.text;
    final name = nameController.text;

    // Перевірка, чи вже є користувачі в базі
    final existingUsers = await userRepository.getAllUsers();
    if (existingUsers.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black, 
          title: Text(
            'Registration failed',
            style: TextStyle(color: Colors.white), 
          ),
          content: Text(
            'A user is already registered.',
            style: TextStyle(color: Colors.white), 
          ),
        ),
      );
      return;
    }

    // Валідація
    if (!email.contains('@') || RegExp(r'[0-9]').hasMatch(name)) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black, 
          title: Text(
            'Invalid data',
            style: TextStyle(color: Colors.white), 
          ),
          content: Text(
            'Please check your email or name.',
            style: TextStyle(color: Colors.white), 
          ),
        ),
      );
      return;
    }

    await userRepository.registerUser(email, password, name);

    Navigator.pushNamed(context, '/profile');
  }

  Future<void> clearDatabase() async {
    await userRepository.clearUsers();
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.black, 
        title: Text(
          'Database cleared',
          style: TextStyle(color: Colors.white), 
        ),
        content: Text(
          'All users have been removed from the database.',
          style: TextStyle(color: Colors.white), 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              labelText: 'Name',
              controller: nameController,
            ),
            CustomTextField(
              labelText: 'Email',
              controller: emailController,
            ),
            CustomTextField(
              labelText: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: clearDatabase,
                child: const Text('Delete previous account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
