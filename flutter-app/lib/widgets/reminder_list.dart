import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderList extends StatelessWidget {
  final List<Reminder> reminders;

  const ReminderList({super.key, required this.reminders});

  Color _getTimeframeColor(String timeframe) {
    switch (timeframe) {
      case 'today': return Colors.red.shade100;
      case 'tomorrow': return Colors.yellow.shade100;
      case 'next week': return Colors.blue.shade100;
      default: return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final limitedReminders = reminders.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reminders (${limitedReminders.length}/2)', 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...limitedReminders.map((reminder) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(reminder.text),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getTimeframeColor(reminder.timeframe),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(reminder.timeframe, style: const TextStyle(fontSize: 12)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => reminder.delete(),
            ),
          ),
        )),
      ],
    );
  }
}
