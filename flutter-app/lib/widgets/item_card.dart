import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../models/reminder.dart';

enum ItemType { task, note, reminder }

class ItemCard extends StatelessWidget {
  final ItemType type;
  final dynamic item;
  final VoidCallback? onToggle;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.type,
    required this.item,
    this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: type == ItemType.task ? onToggle : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (type == ItemType.task) _buildCheckbox(),
              Expanded(child: _buildContent()),
              _buildDeleteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    final task = item as Task;
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 2),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: task.completed ? const Color(0xFF3B82F6) : Colors.transparent,
          border: Border.all(
            color: task.completed ? const Color(0xFF3B82F6) : const Color(0xFFD1D5DB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: task.completed
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getText(),
          style: TextStyle(
            fontSize: 16,
            color: _isCompleted() ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
            decoration: _isCompleted() ? TextDecoration.lineThrough : null,
            height: 1.5,
          ),
        ),
        if (type == ItemType.note) ...[
          const SizedBox(height: 8),
          Text(
            _formatDate((item as Note).date),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
        if (type == ItemType.reminder) ...[
          const SizedBox(height: 8),
          _buildTimeframeBadge(),
        ],
      ],
    );
  }

  Widget _buildTimeframeBadge() {
    final reminder = item as Reminder;
    final colors = _getTimeframeColors(reminder.timeframe);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        border: Border.all(color: colors['border']!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        reminder.timeframe,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors['text'],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, size: 20),
      color: const Color(0xFF9CA3AF),
      onPressed: () => _showDeleteConfirmation(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }

  String _getText() {
    switch (type) {
      case ItemType.task:
        return (item as Task).text;
      case ItemType.note:
        return (item as Note).text;
      case ItemType.reminder:
        return (item as Reminder).text;
    }
  }

  bool _isCompleted() {
    return type == ItemType.task && (item as Task).completed;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  Map<String, Color> _getTimeframeColors(String timeframe) {
    switch (timeframe) {
      case 'today':
        return {
          'bg': const Color(0xFFFEF2F2),
          'border': const Color(0xFFFECACA),
          'text': const Color(0xFFB91C1C),
        };
      case 'tomorrow':
        return {
          'bg': const Color(0xFFFEFCE8),
          'border': const Color(0xFFFDE68A),
          'text': const Color(0xFFA16207),
        };
      case 'next week':
        return {
          'bg': const Color(0xFFEFF6FF),
          'border': const Color(0xFFBFDBFE),
          'text': const Color(0xFF1E40AF),
        };
      default:
        return {
          'bg': const Color(0xFFF3F4F6),
          'border': const Color(0xFFD1D5DB),
          'text': const Color(0xFF6B7280),
        };
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
