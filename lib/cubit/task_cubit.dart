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

  void addTask(String title, String description) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
    );

    final updated = [...state, newTask];
    emit(updated);
    repository.saveTasks(updated);
  }

  void updateTask(int id, String title, String description, {bool? isCompleted}) {
    final updated = state.map((task) {
      if (task.id == id) {
        return task.copyWith(title: title, description: description, isCompleted: isCompleted);
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
