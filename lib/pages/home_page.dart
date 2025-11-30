import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit.dart';
import '../models/task.dart';
import 'edit_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Tracker")),
      body: BlocBuilder<TaskCubit, List<Task>>(
        builder: (context, tasks) {
          if (tasks.isEmpty) return const Center(child: Text("No tasks yet."));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final task = tasks[i];
              return ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null),
                ),
                subtitle: Text(task.description),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
                ),
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => context.read<TaskCubit>().toggleComplete(task.id),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => context.read<TaskCubit>().deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditTaskPage()),
        ),
      ),
    );
  }
}
