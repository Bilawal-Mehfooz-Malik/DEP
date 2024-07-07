import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';

class DbHelper {
  static const String tableTodo = 'TODO_TABLE';
  static const String columnId = 'ID';
  static const String columnTitle = 'TITLE';
  static const String columnDescription = 'DESCRIPTION';
  static const String columnCategory = 'CATEGORY';
  static const String columnDueDate = 'DUE_DATE';
  static const String columnStatus = 'STATUS';

  final String _createTableTodo = '''CREATE TABLE $tableTodo (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTitle TEXT,
      $columnDescription TEXT,
      $columnCategory TEXT,
      $columnDueDate TEXT,
      $columnStatus INTEGER)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = p.join(root, 'todo.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) => db.execute(_createTableTodo),
    );
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await _open();
    return db.insert(tableTodo, todo.toMap());
  }

  Future<List<Todo>> getIncompleteTodos() async {
    final db = await _open();
    final mapList =
        await db.query(tableTodo, where: '$columnStatus=?', whereArgs: [0]);
    return List.generate(mapList.length, (i) => Todo.fromMap(mapList[i]));
  }

  Future<List<Todo>> getCompleteTodos() async {
    final db = await _open();
    final mapList =
        await db.query(tableTodo, where: '$columnStatus=?', whereArgs: [1]);
    return List.generate(mapList.length, (i) => Todo.fromMap(mapList[i]));
  }

  Future<int> deleteTodo(int id) async {
    final db = await _open();
    return db.delete(tableTodo, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> updateTodo(int id, Map<String, dynamic> map) async {
    final db = await _open();
    int res =
        await db.update(tableTodo, map, where: '$columnId=?', whereArgs: [id]);

    return res;
  }

  Future<int> updateStatus(int id, int value) async {
    final db = await _open();
    return db.update(
      tableTodo,
      {columnStatus: value},
      where: '$columnId=?',
      whereArgs: [id],
    );
  }
}
