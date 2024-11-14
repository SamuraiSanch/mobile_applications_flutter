import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HMCE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hamster Combat Criminal Edition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _inputText = '';
  String _imagePath = 'assets/image/base.png'; // Шлях до зображення за замовчуванням

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _checkInput(String input) {
    setState(() {
      if (input == 'cheat') {
        _imagePath = 'assets/image/cheat.jpg';
        _counter = 0; // Скидаємо кількість кліків
      } else if (input == 'fight') {
        _imagePath = 'assets/image/fight.jpg';
        _counter = _counter + 100; // Додаємо до кількості кліків 100 за особливу команду
      } else if (input == 'sword') {
        _imagePath = 'assets/image/sword.jpg';
        _counter = _counter + 200; // Додаємо до кількості кліків 200 за особливу команду
      } else {
        _imagePath = 'assets/image/base.png'; // Зображення за замовчуванням
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('HAMSTER CRIMINAL'),
            GestureDetector(
              onTap: _incrementCounter, // Додає функціонал натискання
              child: Image.asset(
                _imagePath, // Динамічний шлях до зображення
                height: 200,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (text) {
                  _inputText = text;
                  _checkInput(_inputText); // Перевірка введеного тексту
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your prompt',
                ),
              ),
            ),
            Text('You typed: $_inputText'),
          ],
        ),
      ),
    );
  }
}
