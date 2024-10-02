import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    required this.labelText,
    required this.controller, // Додаємо controller як required параметр
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // Використовуємо controller
      obscureText: isPassword,
      decoration: InputDecoration(labelText: labelText),
      style: const TextStyle(color: Colors.white),
    );
  }
}
