import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/today_screen.dart';
import 'models/task.dart';
import 'models/note.dart';
import 'models/reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(ReminderAdapter());
  
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<Reminder>('reminders');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro Life Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodayScreen(),
    );
  }
}
