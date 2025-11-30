import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit.dart';
import '../models/task.dart';
import 'edit_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _priorityBadge(Priority p) {
    Color bg;
    String text;
    switch (p) {
      case Priority.high:
        bg = Colors.redAccent;
        text = 'High';
        break;
      case Priority.medium:
        bg = Colors.orange;
        text = 'Medium';
        break;
      default:
        bg = Colors.green;
        text = 'Low';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bg.withOpacity(0.25)),
      ),
      child: Text(text, style: TextStyle(color: bg, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, sec, child) {
        final tween = Tween(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // gradient app bar via flexibleSpace
      appBar: AppBar(
        title: const Text('Task Tracker'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFF2979FF)]),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFE9F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header
              BlocBuilder<TaskCubit, List<Task>>(
                builder: (context, tasks) {
                  final total = tasks.length;
                  final remaining = tasks.where((t) => !t.isCompleted).length;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello 👋', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('You have $remaining pending • $total total',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                      const SizedBox(height: 12),
                    ],
                  );
                },
              ),

              Expanded(
                child: BlocBuilder<TaskCubit, List<Task>>(
                  builder: (context, tasks) {
                    if (tasks.isEmpty) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Center(
                          key: const ValueKey('empty'),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // simple custom empty state (no external assets)
                              Icon(Icons.task_alt, size: 80, color: Colors.deepPurple.withOpacity(0.15)),
                              const SizedBox(height: 12),
                              Text("No tasks yet", style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 6),
                              Text("Tap + to add your first task", style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      );
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: ListView.builder(
                        key: ValueKey(tasks.length),
                        itemCount: tasks.length,
                        padding: const EdgeInsets.only(bottom: 80),
                        itemBuilder: (context, i) {
                          final task = tasks[i];
                          return Dismissible(
                            key: ValueKey(task.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              context.read<TaskCubit>().deleteTask(task.id);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleted "${task.title}"'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      // To undo we simply re-add (in a real app keep old index)
                                      context.read<TaskCubit>().addTask(task.title, task.description, priority: task.priority);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: (_) => context.read<TaskCubit>().toggleComplete(task.id),
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 8),
                                    _priorityBadge(task.priority),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).push(_createRoute(EditTaskPage(task: task)));
                                  },
                                ),
                                onTap: () {
                                  Navigator.of(context).push(_createRoute(EditTaskPage(task: task)));
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(_createRoute(const EditTaskPage())),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
