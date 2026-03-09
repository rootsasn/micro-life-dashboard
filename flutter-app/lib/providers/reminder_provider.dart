import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/reminder.dart';

// Reminder box provider
final reminderBoxProvider = Provider<Box<Reminder>>((ref) {
  return Hive.box<Reminder>('reminders');
});

// Reminder list provider
final reminderListProvider = StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  final box = ref.watch(reminderBoxProvider);
  return ReminderNotifier(box);
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final Box<Reminder> _box;

  ReminderNotifier(this._box) : super([]) {
    _loadReminders();
  }

  void _loadReminders() {
    state = _box.values.take(2).toList();
  }

  Future<bool> addReminder(String text, String timeframe) async {
    if (_box.length >= 2) {
      return false;
    }

    try {
      final reminder = Reminder(text: text, timeframe: timeframe);
      await _box.add(reminder);
      _loadReminders();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteReminder(int index) async {
    try {
      await _box.deleteAt(index);
      _loadReminders();
    } catch (e) {
      // Handle error
    }
  }

  int get count => _box.length;
}

// Reminder count provider
final reminderCountProvider = Provider<int>((ref) {
  final reminders = ref.watch(reminderListProvider);
  return reminders.length;
});
