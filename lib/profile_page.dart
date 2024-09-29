import 'package:flutter/material.dart';
import 'package:flutter_labs/bottom_navigation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to your profile!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Go to Main Page'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(), // Навігація
    );
  }
}
