import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');
    if (data != null) {
      final list = jsonDecode(data) as List;
      return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', data);
  }
}
