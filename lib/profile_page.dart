import 'package:flutter/material.dart';
import 'package:flutter_labs/bottom_navigation.dart';
import 'package:flutter_labs/user_repository_impl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Завантажуємо дані користувача при ініціалізації сторінки
  }

  Future<void> _loadUserData() async {
    final users = await userRepository.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userName = users.first['name'] as String?; 
        userEmail = users.first['email'] as String?; 
    });
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Якщо дані завантажені, відображаємо їх
            if (userName != null && userEmail != null) ...[
              Text(
                'Hello, $userName!',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your personal data:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $userEmail',
                style: const TextStyle(fontSize: 18),
              ),
            ] else
              // Якщо дані ще не завантажені, показуємо індикатор завантаження
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Thank you, go to Main Page'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
