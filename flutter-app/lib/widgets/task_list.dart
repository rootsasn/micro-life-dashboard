import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final limitedTasks = tasks.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tasks (${limitedTasks.length}/5)', 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...limitedTasks.map((task) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (val) {
                task.completed = val ?? false;
                task.save();
              },
            ),
            title: Text(
              task.text,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
                color: task.completed ? Colors.grey : Colors.black,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => task.delete(),
            ),
          ),
        )),
      ],
    );
  }
}
