import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_app/model/todo.dart';
import 'package:todo_app/data/todo_provider.dart';
import 'package:todo_app/utils/date_formatter.dart';
import 'package:todo_app/todo_detail/todo_detail_screen.dart';

class TodosListTile extends ConsumerWidget {
  const TodosListTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var container = Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),

      // [Dismissible Widget]
      child: Dismissible(
        background: container,
        key: ValueKey(todo.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _deleteTodo(context, ref),

        // [List Tile]
        child: ListTile(
          title: Text(todo.title),
          subtitle: Text('${todo.category} - ${formatDate(todo.dueDate)}'),
          trailing: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _markAsComplete(context, ref),
          ),
          onTap: () => _navigateToDetailsScreen(context),
        ),
      ),
    );
  }

  void _navigateToDetailsScreen(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) => TodoDetailScreen(todo: todo),
      ),
    );
  }

  Future<void> _deleteTodo(BuildContext ctx, WidgetRef ref) async {
    await ref.read(todoNotifierProvider.notifier).deleteTodoById(todo.id);
  }

  Future<void> _markAsComplete(BuildContext context, WidgetRef ref) async {
    await ref.read(todoNotifierProvider.notifier).updateTodoStatus(todo.id, 1);
  }
}
