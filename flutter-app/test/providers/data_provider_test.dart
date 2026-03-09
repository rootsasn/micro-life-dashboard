import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:micro_life_dashboard/providers/data_provider.dart';
import 'package:micro_life_dashboard/models/task.dart';
import 'package:micro_life_dashboard/models/note.dart';
import 'package:micro_life_dashboard/models/reminder.dart';

void main() {
  late DataProvider dataProvider;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(ReminderAdapter());
  });

  setUp(() async {
    dataProvider = DataProvider();
    await dataProvider.initialize();
    await dataProvider.clearAll();
  });

  tearDown(() async {
    await dataProvider.clearAll();
  });

  group('DataProvider', () {
    test('initializes successfully', () {
      expect(dataProvider.isInitialized, true);
      expect(dataProvider.taskCount, 0);
      expect(dataProvider.noteCount, 0);
      expect(dataProvider.reminderCount, 0);
    });

    test('adds task successfully', () async {
      final result = await dataProvider.addTask('Test task');
      expect(result, true);
      expect(dataProvider.taskCount, 1);
      expect(dataProvider.tasks.first.text, 'Test task');
    });

    test('enforces 5 task limit', () async {
      for (var i = 0; i < 5; i++) {
        await dataProvider.addTask('Task $i');
      }
      
      final result = await dataProvider.addTask('Task 6');
      expect(result, false);
      expect(dataProvider.taskCount, 5);
    });

    test('toggles task completion', () async {
      await dataProvider.addTask('Test task');
      expect(dataProvider.tasks.first.completed, false);
      
      await dataProvider.toggleTask(0);
      expect(dataProvider.tasks.first.completed, true);
      
      await dataProvider.toggleTask(0);
      expect(dataProvider.tasks.first.completed, false);
    });

    test('deletes task', () async {
      await dataProvider.addTask('Test task');
      expect(dataProvider.taskCount, 1);
      
      await dataProvider.deleteTask(0);
      expect(dataProvider.taskCount, 0);
    });

    test('adds note successfully', () async {
      final result = await dataProvider.addNote('Test note');
      expect(result, true);
      expect(dataProvider.noteCount, 1);
      expect(dataProvider.notes.first.text, 'Test note');
    });

    test('enforces 5 note limit', () async {
      for (var i = 0; i < 5; i++) {
        await dataProvider.addNote('Note $i');
      }
      
      final result = await dataProvider.addNote('Note 6');
      expect(result, false);
      expect(dataProvider.noteCount, 5);
    });

    test('adds reminder successfully', () async {
      final result = await dataProvider.addReminder('Test reminder', 'today');
      expect(result, true);
      expect(dataProvider.reminderCount, 1);
      expect(dataProvider.reminders.first.text, 'Test reminder');
      expect(dataProvider.reminders.first.timeframe, 'today');
    });

    test('enforces 2 reminder limit', () async {
      await dataProvider.addReminder('Reminder 1', 'today');
      await dataProvider.addReminder('Reminder 2', 'tomorrow');
      
      final result = await dataProvider.addReminder('Reminder 3', 'next week');
      expect(result, false);
      expect(dataProvider.reminderCount, 2);
    });

    test('clears all data', () async {
      await dataProvider.addTask('Task');
      await dataProvider.addNote('Note');
      await dataProvider.addReminder('Reminder', 'today');
      
      await dataProvider.clearAll();
      
      expect(dataProvider.taskCount, 0);
      expect(dataProvider.noteCount, 0);
      expect(dataProvider.reminderCount, 0);
    });
  });
}
