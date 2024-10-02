import 'package:flutter_labs/goal.dart';

abstract class GoalRepository {
  Future<void> addGoal(Goal goal);
  Future<List<Goal>> getAllGoals();
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(int id);
}
