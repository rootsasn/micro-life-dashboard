import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/note_provider.dart';
import '../providers/reminder_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/add_bottom_sheet.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider);
    final notes = ref.watch(noteListProvider);
    final reminders = ref.watch(reminderListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Today',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Text(
                  _formatDate(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTasksSection(context, ref, tasks),
          const SizedBox(height: 24),
          _buildNotesSection(context, ref, notes),
          const SizedBox(height: 24),
          _buildRemindersSection(context, ref, reminders),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBottomSheet(context),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context, WidgetRef ref, List tasks) {
    final taskCount = ref.watch(taskCountProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Tasks', taskCount, 5),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          const EmptyState(
            icon: Icons.check_box_outlined,
            message: 'No tasks yet',
          )
        else
          ...List.generate(tasks.length, (index) {
            final task = tasks[index];
            return ItemCard(
              type: ItemType.task,
              item: task,
              onToggle: () => ref.read(taskListProvider.notifier).toggleTask(index),
              onDelete: () => ref.read(taskListProvider.notifier).deleteTask(index),
            );
          }),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context, WidgetRef ref, List notes) {
    final noteCount = ref.watch(noteCountProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notes', noteCount, 5),
        const SizedBox(height: 12),
        if (notes.isEmpty)
          const EmptyState(
            icon: Icons.note_outlined,
            message: 'No notes yet',
          )
        else
          ...List.generate(notes.length, (index) {
            final note = notes[index];
            return ItemCard(
              type: ItemType.note,
              item: note,
              onDelete: () => ref.read(noteListProvider.notifier).deleteNote(index),
            );
          }),
      ],
    );
  }

  Widget _buildRemindersSection(BuildContext context, WidgetRef ref, List reminders) {
    final reminderCount = ref.watch(reminderCountProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Reminders', reminderCount, 2),
        const SizedBox(height: 12),
        if (reminders.isEmpty)
          const EmptyState(
            icon: Icons.notifications_outlined,
            message: 'No reminders yet',
          )
        else
          ...List.generate(reminders.length, (index) {
            final reminder = reminders[index];
            return ItemCard(
              type: ItemType.reminder,
              item: reminder,
              onDelete: () => ref.read(reminderListProvider.notifier).deleteReminder(index),
            );
          }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count, int max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count/$max',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddBottomSheet(),
    );
  }
}
