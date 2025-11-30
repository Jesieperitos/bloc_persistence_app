import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';

class TaskCubit extends Cubit<List<Task>> {
  final TaskRepository repository;

  TaskCubit(this.repository) : super([]) {
    loadTasks();
  }

  void loadTasks() async {
    final tasks = await repository.loadTasks();
    emit(tasks);
  }

  void addTask(String title, String description, {Priority priority = Priority.medium}) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      priority: priority,
    );

    final updated = [...state, newTask];
    emit(updated);
    repository.saveTasks(updated);
  }

  void updateTask(int id, String title, String description, {bool? isCompleted, Priority? priority}) {
    final updated = state.map((task) {
      if (task.id == id) {
        return task.copyWith(title: title, description: description, isCompleted: isCompleted, priority: priority);
      }
      return task;
    }).toList();

    emit(updated);
    repository.saveTasks(updated);
  }

  void deleteTask(int id) {
    final updated = state.where((task) => task.id != id).toList();
    emit(updated);
    repository.saveTasks(updated);
  }

  void toggleComplete(int id) {
    final updated = state.map((task) {
      if (task.id == id) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();

    emit(updated);
    repository.saveTasks(updated);
  }
}
