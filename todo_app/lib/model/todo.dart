import 'package:todo_app/data/db_helper.dart';

class Todo {
  int id;
  String title;
  String description;
  String category;
  DateTime dueDate;
  bool status;

  Todo({
    this.id = -1,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    this.status = false,
  });

  Map<String, dynamic> toMap() {
    final map = {
      DbHelper.columnTitle: title,
      DbHelper.columnDescription: description,
      DbHelper.columnCategory: category,
      DbHelper.columnDueDate: dueDate.toIso8601String(),
      DbHelper.columnStatus: status ? 1 : 0,
    };
    if (id > 0) {
      map[DbHelper.columnId] = id;
    }
    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map[DbHelper.columnId] ?? -1,
      title: map[DbHelper.columnTitle] ?? '',
      description: map[DbHelper.columnDescription] ?? '',
      category: map[DbHelper.columnCategory] ?? '',
      dueDate: map[DbHelper.columnDueDate] != null
          ? DateTime.parse(map[DbHelper.columnDueDate])
          : DateTime.now(),
      status: map[DbHelper.columnStatus] == 1,
    );
  }
}
