import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_app/model/todo.dart';
import 'package:todo_app/data/todo_provider.dart';
import 'package:todo_app/my_todos/todo_list_tile.dart';
import 'package:todo_app/common/async_value_widget.dart';

class TodosListView extends ConsumerWidget {
  const TodosListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosValue = ref.watch(todoNotifierProvider);

    return AsyncValueWidget<List<Todo>>(
      value: todosValue,
      data: (todos) {
        return todos.isEmpty
            ? const Center(child: Text('No todos available'))
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return TodosListTile(todo: todo);
                },
              );
      },
    );
  }
}
