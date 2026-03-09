import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late DateTime date;

  Note({required this.text, DateTime? date}) {
    this.date = date ?? DateTime.now();
  }
}
