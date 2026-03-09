import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAddOption(context, 'Task', Icons.check_box, () => _showAddDialog(context, 'task')),
            _buildAddOption(context, 'Note', Icons.note, () => _showAddDialog(context, 'note')),
            _buildAddOption(context, 'Reminder', Icons.alarm, () => _showAddDialog(context, 'reminder')),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 32),
      title: Text(label, style: const TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showAddDialog(BuildContext context, String type) {
    final controller = TextEditingController();
    String timeframe = 'today';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter $type...'),
              autofocus: true,
            ),
            if (type == 'reminder') ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: timeframe,
                items: ['today', 'tomorrow', 'next week']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => timeframe = val ?? 'today',
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addItem(type, controller.text, timeframe);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addItem(String type, String text, String timeframe) {
    if (type == 'task') {
      final box = Hive.box<Task>('tasks');
      if (box.length < 5) box.add(Task(text: text));
    } else if (type == 'note') {
      final box = Hive.box<Note>('notes');
      if (box.length < 5) box.add(Note(text: text));
    } else if (type == 'reminder') {
      final box = Hive.box<Reminder>('reminders');
      if (box.length < 2) box.add(Reminder(text: text, timeframe: timeframe));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddMenu(context),
      child: const Icon(Icons.add, size: 32),
    );
  }
}
