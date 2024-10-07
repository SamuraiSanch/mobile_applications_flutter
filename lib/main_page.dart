import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_labs/bottom_navigation.dart';
import 'package:flutter_labs/goal.dart';
import 'package:flutter_labs/goal_repository_impl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GoalRepositoryImpl goalRepository = GoalRepositoryImpl();
  List<Goal> goals = [];
  final TextEditingController goalController = TextEditingController();

  late StreamSubscription<List<ConnectivityResult>> subscription; 
  bool _isOffline = false; 

  @override
  void initState() {
    super.initState();
    _loadGoals();
    
   
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
      if (resultList.isNotEmpty && resultList.contains(ConnectivityResult.none)) {
        setState(() {
          _isOffline = true;
        });
        _showConnectionLostDialog();
      } else {
        setState(() {
          _isOffline = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkConnectivity(); // Перевірка стану з'єднання при кожному поверненні
  }

  @override
  void dispose() {
    subscription.cancel();
    goalController.dispose(); 
    super.dispose();
  }

  // Перевірка стану інтернету
  void _checkConnectivity() {
    Connectivity().checkConnectivity().then((connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          _isOffline = true;
        });
        _showConnectionLostDialog();
      } else {
        setState(() {
          _isOffline = false;
        });
      }
    });
  }

  Future<void> _loadGoals() async {
    final loadedGoals = await goalRepository.getAllGoals();
    setState(() {
      goals = loadedGoals;
    });
  }

  Future<void> _addGoal() async {
    final String text = goalController.text;
    if (_isOffline) {
      _showErrorDialog('No internet connection. Please connect to the internet to add a goal.');
    } else if (text.isNotEmpty) {
      final newGoal = Goal(text: text);
      await goalRepository.addGoal(newGoal);
      _loadGoals();
      goalController.clear();
    } else {
      _showErrorDialog('Please enter a goal.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Error',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConnectionLostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Connection Lost',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Your internet connection has been lost.',
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
  }

  Future<void> _toggleGoalCompletion(Goal goal) async {
    final updatedGoal = Goal(id: goal.id, text: goal.text, isCompleted: !goal.isCompleted);
    await goalRepository.updateGoal(updatedGoal);
    _loadGoals();
  }

  Future<void> _deleteGoal(int? id) async {
    if (id != null) {
      await goalRepository.deleteGoal(id);
      _loadGoals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Page')),
      body: CustomPaint(
        painter: BrickWallPainter(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '|-|-| Wall |-|-|',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return ListTile(
                    title: Text(
                      goal.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: goal.isCompleted ? Colors.green : Colors.white,
                        decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            goal.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                            color: Colors.white,
                          ),
                          onPressed: () => _toggleGoalCompletion(goal),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteGoal(goal.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: goalController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter your goal',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _addGoal,
                  ),
                ],
              ),
            ),
            if (_isOffline)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'No internet connection. Cannot add goals.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
class BrickWallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800 
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const brickHeight = 40.0;
    const brickWidth = 80.0;
    const offsetY = 5.0; // Вертикальна відстань між рядами
    const verticalShift = -23.0; // Зміщення текстури вгору

    for (double y = verticalShift; y < size.height; y += brickHeight + offsetY){
      final bool offset = (y / (brickHeight + offsetY)).toInt() % 2 == 1;

      for (double x = offset ? -brickWidth / 2 : 0; x < size.width; x += brickWidth) { 
        canvas.drawRect(
          Rect.fromLTWH(x, y, brickWidth, brickHeight),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
