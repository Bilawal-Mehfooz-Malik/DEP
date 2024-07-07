import 'package:todo_app/model/todo.dart';
import 'package:todo_app/data/db_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoNotifier(this._dbHelper) : super(const AsyncLoading());

  final DbHelper _dbHelper;

  Future<void> fetchIncompleteTodos() async {
    try {
      final todos = await _dbHelper.getIncompleteTodos();
      state = AsyncData(todos);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> fetchCompleteTodos() async {
    try {
      final todos = await _dbHelper.getCompleteTodos();
      state = AsyncData(todos);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await _dbHelper.insertTodo(todo);
      fetchIncompleteTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteTodoById(int id) async {
    try {
      await _dbHelper.deleteTodo(id);
      state = state.whenData((todos) {
        return todos.where((todo) => todo.id != id).toList();
      });
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateTodoStatus(int id, int status) async {
    try {
      await _dbHelper.updateStatus(id, status);
      fetchIncompleteTodos();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<Todo?> updateTodo(int id, Todo todo) async {
    try {
      await _dbHelper.updateTodo(id, todo.toMap());
      fetchIncompleteTodos();
      return todo;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

final dbHelperProvider = Provider<DbHelper>((ref) {
  return DbHelper();
});

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, AsyncValue<List<Todo>>>((ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return TodoNotifier(dbHelper);
});
