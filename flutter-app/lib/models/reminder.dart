import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 2)
class Reminder extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late String timeframe;

  Reminder({required this.text, required this.timeframe});
}
