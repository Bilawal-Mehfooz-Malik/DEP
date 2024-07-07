import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utils/date_formatter.dart';
import 'package:todo_app/data/todo_provider.dart';
import 'package:todo_app/add_update_todo/add_update_todo_screen.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Description: ${todo.description}'),
            const Gap(12),
            Text('Category: ${todo.category}'),
            const Gap(12),
            Text('Due Date: ${formatDate(todo.dueDate)}'),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () => _editTodo(context, ref),
                  child: const Text('Edit Todo'),
                );
              },
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(todo.title),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            return IconButton(
              onPressed: () => _showDeleteDialog(context, ref),
              icon: const Icon(Icons.delete),
            );
          },
        )
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure to delete this todo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => _deleteTodo(ref, context),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editTodo(BuildContext ctx, WidgetRef ref) {
    showModalBottomSheet(
      context: ctx,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return AddUpDateTodoScreen(
          todo: todo,
          title: 'Edit Existing Todo',
          buttonText: 'Update Todo',
          onSubmit: (todo) => _updateTodo(ref, todo, context),
        );
      },
    );
  }

  void _updateTodo(WidgetRef ref, Todo todo, BuildContext ctx) async {
    await ref.read(todoNotifierProvider.notifier).updateTodo(todo.id, todo);
    if (ctx.mounted) {
      Navigator.of(ctx).pop();
      Navigator.of(ctx).pop();
    }
  }

  void _deleteTodo(WidgetRef ref, BuildContext ctx) {
    ref.read(todoNotifierProvider.notifier).deleteTodoById(todo.id);
    Navigator.of(ctx).pop();
    Navigator.of(ctx).pop();
  }
}
