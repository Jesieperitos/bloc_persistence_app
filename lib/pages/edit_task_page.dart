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

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descController.text = widget.task!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Task" : "Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                  );
                } else {
                  context.read<TaskCubit>().addTask(title, desc);
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? "Update Task" : "Add Task"),
            )
          ],
        ),
      ),
    );
  }
}
