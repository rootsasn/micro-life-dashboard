import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:micro_life_dashboard/main.dart';
import 'package:micro_life_dashboard/models/task.dart';
import 'package:micro_life_dashboard/models/note.dart';
import 'package:micro_life_dashboard/models/reminder.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(ReminderAdapter());
  });

  testWidgets('App loads with HomeScreen', (WidgetTester tester) async {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Note>('notes');
    await Hive.openBox<Reminder>('reminders');

    await tester.pumpWidget(const MyApp());
    
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
  });

  testWidgets('Shows empty states when no items', (WidgetTester tester) async {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Note>('notes');
    await Hive.openBox<Reminder>('reminders');

    await tester.pumpWidget(const MyApp());
    
    expect(find.text('No tasks yet'), findsOneWidget);
    expect(find.text('No notes yet'), findsOneWidget);
    expect(find.text('No reminders yet'), findsOneWidget);
  });

  testWidgets('FAB opens add bottom sheet', (WidgetTester tester) async {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Note>('notes');
    await Hive.openBox<Reminder>('reminders');

    await tester.pumpWidget(const MyApp());
    
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    
    await tester.tap(fab);
    await tester.pumpAndSettle();
    
    expect(find.text('Add New Item'), findsOneWidget);
  });
}
