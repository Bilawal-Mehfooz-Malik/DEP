import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todo_app/data/todo_provider.dart';
import 'package:todo_app/history/completed_todos_screen.dart';
import 'package:todo_app/my_todos/todos_list_view.dart';
import 'package:todo_app/add_update_todo/add_update_todo_screen.dart';

class MyTodosScreen extends ConsumerStatefulWidget {
  const MyTodosScreen({super.key});

  @override
  ConsumerState<MyTodosScreen> createState() => _MyTodosScreenState();
}

class _MyTodosScreenState extends ConsumerState<MyTodosScreen> {
  @override
  void initState() {
    ref.read(todoNotifierProvider.notifier).fetchIncompleteTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: TodosListView(),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return _floatingActionButton(context, ref);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('My Todos'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CompletedTodosScreen(),
              ),
            );
          },
          icon: const Icon(Icons.history),
        ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext ctx, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showAddTodoBottomSheet(ctx, ref),
      child: const Icon(Icons.add),
    );
  }

  void _showAddTodoBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return AddUpDateTodoScreen(
          title: 'Add New Todo',
          buttonText: 'Add Todo',
          todo: null,
          onSubmit: (todo) async {
            await ref.read(todoNotifierProvider.notifier).addTodo(todo);
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
