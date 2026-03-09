import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late bool completed;

  @HiveField(2)
  late int timestamp;

  Task({required this.text, this.completed = false, int? timestamp}) {
    this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
  }
}
