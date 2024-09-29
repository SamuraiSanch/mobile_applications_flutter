import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Відстань між фото
        children: [
          GestureDetector(
            onTap: () {
              // При натисканні нічого не відбувається - ця кнопка для лаб7
            },
            child: Image.asset(
              'assets/secret.png',
              height: 50, // Висота зображення
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/main'); // main page
            },
            child: Image.asset(
              'assets/wall.png',
              height: 50,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile'); // profile page
            },
            child: Image.asset(
              'assets/user.png',
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
