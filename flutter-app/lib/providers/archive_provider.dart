import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';

// Archive service provider
final archiveServiceProvider = Provider<ArchiveService>((ref) {
  return ArchiveService();
});

class ArchiveService {
  // Auto-archive items older than 7 days
  Future<ArchiveResult> archiveOldItems() async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final sevenDaysAgoMs = sevenDaysAgo.millisecondsSinceEpoch;

      int tasksArchived = 0;
      int notesArchived = 0;
      int remindersArchived = 0;

      // Archive old completed tasks
      final taskBox = Hive.box<Task>('tasks');
      final tasksToDelete = <int>[];
      
      for (var i = 0; i < taskBox.length; i++) {
        final task = taskBox.getAt(i);
        if (task != null && task.completed && task.timestamp < sevenDaysAgoMs) {
          tasksToDelete.add(i);
        }
      }
      
      for (var index in tasksToDelete.reversed) {
        await taskBox.deleteAt(index);
        tasksArchived++;
      }

      // Archive old notes
      final noteBox = Hive.box<Note>('notes');
      final notesToDelete = <int>[];
      
      for (var i = 0; i < noteBox.length; i++) {
        final note = noteBox.getAt(i);
        if (note != null && note.date.isBefore(sevenDaysAgo)) {
          notesToDelete.add(i);
        }
      }
      
      for (var index in notesToDelete.reversed) {
        await noteBox.deleteAt(index);
        notesArchived++;
      }

      // Archive old reminders (optional - keep for now)
      // Reminders are typically short-lived, so we might want different logic

      if (tasksArchived > 0 || notesArchived > 0) {
        debugPrint('Auto-archived: $tasksArchived tasks, $notesArchived notes');
      }

      return ArchiveResult(
        tasksArchived: tasksArchived,
        notesArchived: notesArchived,
        remindersArchived: remindersArchived,
      );
    } catch (e) {
      debugPrint('Error archiving old items: $e');
      return ArchiveResult(
        tasksArchived: 0,
        notesArchived: 0,
        remindersArchived: 0,
      );
    }
  }

  // Manual archive trigger
  Future<ArchiveResult> manualArchive() async {
    return await archiveOldItems();
  }
}

class ArchiveResult {
  final int tasksArchived;
  final int notesArchived;
  final int remindersArchived;

  ArchiveResult({
    required this.tasksArchived,
    required this.notesArchived,
    required this.remindersArchived,
  });

  int get total => tasksArchived + notesArchived + remindersArchived;
}

// Auto-archive on app start provider
final autoArchiveProvider = FutureProvider<ArchiveResult>((ref) async {
  final archiveService = ref.watch(archiveServiceProvider);
  return await archiveService.archiveOldItems();
});
