import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';

class DataProvider extends ChangeNotifier {
  late Box<Task> _taskBox;
  late Box<Note> _noteBox;
  late Box<Reminder> _reminderBox;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  List<Task> get tasks => _taskBox.values.take(5).toList();
  List<Note> get notes => _noteBox.values.take(5).toList();
  List<Reminder> get reminders => _reminderBox.values.take(2).toList();

  int get taskCount => _taskBox.length;
  int get noteCount => _noteBox.length;
  int get reminderCount => _reminderBox.length;

  Future<void> initialize() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TaskAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(NoteAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ReminderAdapter());
      }

      // Open boxes
      _taskBox = await Hive.openBox<Task>('tasks');
      _noteBox = await Hive.openBox<Note>('notes');
      _reminderBox = await Hive.openBox<Reminder>('reminders');

      // Clean old items on startup
      await deleteOldItems();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      rethrow;
    }
  }

  // Task operations
  Future<bool> addTask(String text) async {
    if (_taskBox.length >= 5) {
      return false;
    }

    try {
      final task = Task(text: text);
      await _taskBox.add(task);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding task: $e');
      return false;
    }
  }

  Future<void> toggleTask(int index) async {
    try {
      final task = _taskBox.getAt(index);
      if (task != null) {
        task.completed = !task.completed;
        task.timestamp = DateTime.now().millisecondsSinceEpoch;
        await task.save();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling task: $e');
    }
  }

  Future<void> deleteTask(int index) async {
    try {
      await _taskBox.deleteAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting task: $e');
    }
  }

  // Note operations
  Future<bool> addNote(String text) async {
    if (_noteBox.length >= 5) {
      return false;
    }

    try {
      final note = Note(text: text);
      await _noteBox.add(note);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding note: $e');
      return false;
    }
  }

  Future<void> deleteNote(int index) async {
    try {
      await _noteBox.deleteAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting note: $e');
    }
  }

  // Reminder operations
  Future<bool> addReminder(String text, String timeframe) async {
    if (_reminderBox.length >= 2) {
      return false;
    }

    try {
      final reminder = Reminder(text: text, timeframe: timeframe);
      await _reminderBox.add(reminder);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding reminder: $e');
      return false;
    }
  }

  Future<void> deleteReminder(int index) async {
    try {
      await _reminderBox.deleteAt(index);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
    }
  }

  // Delete old items (7 days)
  Future<void> deleteOldItems() async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final sevenDaysAgoMs = sevenDaysAgo.millisecondsSinceEpoch;

      // Delete old completed tasks
      final tasksToDelete = <int>[];
      for (var i = 0; i < _taskBox.length; i++) {
        final task = _taskBox.getAt(i);
        if (task != null && task.completed && task.timestamp < sevenDaysAgoMs) {
          tasksToDelete.add(i);
        }
      }
      for (var index in tasksToDelete.reversed) {
        await _taskBox.deleteAt(index);
      }

      // Delete old notes
      final notesToDelete = <int>[];
      for (var i = 0; i < _noteBox.length; i++) {
        final note = _noteBox.getAt(i);
        if (note != null && note.date.isBefore(sevenDaysAgo)) {
          notesToDelete.add(i);
        }
      }
      for (var index in notesToDelete.reversed) {
        await _noteBox.deleteAt(index);
      }

      // Delete old reminders
      final remindersToDelete = <int>[];
      for (var i = 0; i < _reminderBox.length; i++) {
        final reminder = _reminderBox.getAt(i);
        // For reminders, we'll keep them unless they're very old
        // You can customize this logic based on your needs
      }

      if (tasksToDelete.isNotEmpty || notesToDelete.isNotEmpty) {
        debugPrint('Deleted ${tasksToDelete.length} old tasks and ${notesToDelete.length} old notes');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting old items: $e');
    }
  }

  // Clear all data (for testing/reset)
  Future<void> clearAll() async {
    try {
      await _taskBox.clear();
      await _noteBox.clear();
      await _reminderBox.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing data: $e');
    }
  }

  // Get item by key for direct manipulation
  Task? getTask(int index) => _taskBox.getAt(index);
  Note? getNote(int index) => _noteBox.getAt(index);
  Reminder? getReminder(int index) => _reminderBox.getAt(index);

  @override
  void dispose() {
    // Boxes are closed when app terminates
    // No need to close here as they're managed by Hive
    super.dispose();
  }
}
