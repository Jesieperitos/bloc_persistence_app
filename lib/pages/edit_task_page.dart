import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../cubit/task_cubit.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;
  const EditTaskPage({super.key, this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  Priority priority = Priority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descController.text = widget.task!.description;
      priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Task" : "Add Task"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Priority>(
              value: priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: Priority.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => priority = v);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final desc = descController.text.trim();
                  if (title.isEmpty) return;

                  if (isEditing) {
                    context.read<TaskCubit>().updateTask(
                      widget.task!.id,
                      title,
                      desc,
                      isCompleted: widget.task!.isCompleted,
                      priority: priority,
                    );
                  } else {
                    context.read<TaskCubit>().addTask(title, desc, priority: priority);
                  }

                  Navigator.of(context).pop();
                },
                child: Text(isEditing ? "Update Task" : "Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
