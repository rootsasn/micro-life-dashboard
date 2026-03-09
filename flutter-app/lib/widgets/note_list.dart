import 'package:flutter/material.dart';
import '../models/note.dart';
import 'package:intl/intl.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;

  const NoteList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final limitedNotes = notes.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes (${limitedNotes.length}/5)', 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...limitedNotes.map((note) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(note.text),
            subtitle: Text(DateFormat('MMM d').format(note.date)),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => note.delete(),
            ),
          ),
        )),
      ],
    );
  }
}
