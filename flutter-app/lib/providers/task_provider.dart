import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

// Task box provider
final taskBoxProvider = Provider<Box<Task>>((ref) {
  return Hive.box<Task>('tasks');
});

// Task list provider
final taskListProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final box = ref.watch(taskBoxProvider);
  return TaskNotifier(box);
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final Box<Task> _box;

  TaskNotifier(this._box) : super([]) {
    _loadTasks();
  }

  void _loadTasks() {
    state = _box.values.take(5).toList();
  }

  Future<bool> addTask(String text) async {
    if (_box.length >= 5) {
      return false;
    }

    try {
      final task = Task(text: text);
      await _box.add(task);
      _loadTasks();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleTask(int index) async {
    try {
      final task = _box.getAt(index);
      if (task != null) {
        task.completed = !task.completed;
        task.timestamp = DateTime.now().millisecondsSinceEpoch;
        await task.save();
        _loadTasks();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteTask(int index) async {
    try {
      await _box.deleteAt(index);
      _loadTasks();
    } catch (e) {
      // Handle error
    }
  }

  int get count => _box.length;
}

// Task count provider
final taskCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.length;
});
