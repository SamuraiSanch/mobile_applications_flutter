import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_labs/goal.dart';
import 'package:flutter_labs/goal_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GoalRepositoryImpl implements GoalRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('goals_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE goals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<void> addGoal(Goal goal) async {
    final db = await database;
    await db.insert('goals', goal.toMap());
  }

  @override
  Future<List<Goal>> getAllGoals() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('goals');
    return List.generate(maps.length, (i) {
      return Goal.fromMap(maps[i]);
    });
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    final db = await database;
    await db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  @override
  Future<void> deleteGoal(int id) async {
    final db = await database;
    await db.delete('goals', where: 'id = ?', whereArgs: [id]);
  }

  // Метод для додавання цілі з перевіркою інтернет-з'єднання
  Future<void> addGoalWithInternetCheck(BuildContext context, Goal goal) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      // Показати діалогове вікно про відсутність інтернету
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
              'You cannot add new goals without an internet connection.',
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
      
      await addGoal(goal); // Викликається метод для додавання цілі
    }
  }
}
