import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';
import '../widgets/task_list.dart';
import '../widgets/note_list.dart';
import '../widgets/reminder_list.dart';
import '../widgets/add_button.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Today', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<Task>('tasks').listenable(),
              builder: (context, Box<Task> box, _) {
                return TaskList(tasks: box.values.toList());
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: Hive.box<Note>('notes').listenable(),
              builder: (context, Box<Note> box, _) {
                return NoteList(notes: box.values.toList());
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder(
              valueListenable: Hive.box<Reminder>('reminders').listenable(),
              builder: (context, Box<Reminder> box, _) {
                return ReminderList(reminders: box.values.toList());
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: const AddButton(),
    );
  }
}
