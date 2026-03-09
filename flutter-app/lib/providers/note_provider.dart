import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

// Note box provider
final noteBoxProvider = Provider<Box<Note>>((ref) {
  return Hive.box<Note>('notes');
});

// Note list provider
final noteListProvider = StateNotifierProvider<NoteNotifier, List<Note>>((ref) {
  final box = ref.watch(noteBoxProvider);
  return NoteNotifier(box);
});

class NoteNotifier extends StateNotifier<List<Note>> {
  final Box<Note> _box;

  NoteNotifier(this._box) : super([]) {
    _loadNotes();
  }

  void _loadNotes() {
    state = _box.values.take(5).toList();
  }

  Future<bool> addNote(String text) async {
    if (_box.length >= 5) {
      return false;
    }

    try {
      final note = Note(text: text);
      await _box.add(note);
      _loadNotes();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteNote(int index) async {
    try {
      await _box.deleteAt(index);
      _loadNotes();
    } catch (e) {
      // Handle error
    }
  }

  int get count => _box.length;
}

// Note count provider
final noteCountProvider = Provider<int>((ref) {
  final notes = ref.watch(noteListProvider);
  return notes.length;
});
