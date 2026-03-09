import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/note_provider.dart';
import '../providers/reminder_provider.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';

enum AddStep { menu, task, note, reminder }

class AddBottomSheet extends ConsumerStatefulWidget {
  const AddBottomSheet({super.key});

  @override
  ConsumerState<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends ConsumerState<AddBottomSheet> {
  AddStep _currentStep = AddStep.menu;
  final _textController = TextEditingController();
  String _selectedTimeframe = 'today';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: _currentStep == AddStep.menu
                    ? _buildMenu()
                    : _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getHeaderTitle(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentStep) {
      case AddStep.menu:
        return 'Add New Item';
      case AddStep.task:
        return 'Add Task';
      case AddStep.note:
        return 'Add Note';
      case AddStep.reminder:
        return 'Add Reminder';
    }
  }

  Widget _buildMenu() {
    final taskCount = ref.watch(taskCountProvider);
    final noteCount = ref.watch(noteCountProvider);
    final reminderCount = ref.watch(reminderCountProvider);

    return Column(
      children: [
        _buildMenuOption(
          icon: Icons.check_box_outlined,
          iconColor: const Color(0xFF3B82F6),
          iconBg: const Color(0xFFDCEEFE),
          title: 'Add Task',
          subtitle: '$taskCount/5 tasks',
          onTap: () => _setStep(AddStep.task),
          enabled: taskCount < 5,
        ),
        const SizedBox(height: 12),
        _buildMenuOption(
          icon: Icons.note_outlined,
          iconColor: const Color(0xFF10B981),
          iconBg: const Color(0xFFD1FAE5),
          title: 'Add Note',
          subtitle: '$noteCount/5 notes',
          onTap: () => _setStep(AddStep.note),
          enabled: noteCount < 5,
        ),
        const SizedBox(height: 12),
        _buildMenuOption(
          icon: Icons.notifications_outlined,
          iconColor: const Color(0xFF8B5CF6),
          iconBg: const Color(0xFFEDE9FE),
          title: 'Add Reminder',
          subtitle: '$reminderCount/2 reminders',
          onTap: () => _setStep(AddStep.reminder),
          enabled: reminderCount < 2,
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: enabled ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _textController,
          autofocus: true,
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Enter ${_currentStep.name}...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        if (_currentStep == AddStep.reminder) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedTimeframe,
            decoration: InputDecoration(
              labelText: 'When',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: const [
              DropdownMenuItem(value: 'today', child: Text('Today')),
              DropdownMenuItem(value: 'tomorrow', child: Text('Tomorrow')),
              DropdownMenuItem(value: 'next week', child: Text('Next Week')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedTimeframe = value);
              }
            },
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _handleAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => setState(() => _currentStep = AddStep.menu),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Back'),
            ),
          ],
        ),
      ],
    );
  }

  void _setStep(AddStep step) {
    setState(() {
      _currentStep = step;
      _textController.clear();
    });
  }

  void _handleAdd() async {
    if (_textController.text.trim().isEmpty) return;

    final text = _textController.text.trim();
    bool success = false;

    switch (_currentStep) {
      case AddStep.task:
        success = await ref.read(taskListProvider.notifier).addTask(text);
        break;
      case AddStep.note:
        success = await ref.read(noteListProvider.notifier).addNote(text);
        break;
      case AddStep.reminder:
        success = await ref.read(reminderListProvider.notifier).addReminder(text, _selectedTimeframe);
        break;
      case AddStep.menu:
        break;
    }

    if (success && mounted) {
      Navigator.pop(context);
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum limit reached')),
      );
    }
  }
}
