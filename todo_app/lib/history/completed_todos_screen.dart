import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/data/todo_provider.dart';
import 'package:todo_app/my_todos/todo_list_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/common/async_value_widget.dart';

class CompletedTodosScreen extends ConsumerStatefulWidget {
  const CompletedTodosScreen({super.key});

  @override
  ConsumerState<CompletedTodosScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<CompletedTodosScreen> {
  @override
  void initState() {
    ref.read(todoNotifierProvider.notifier).fetchCompleteTodos();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ref.read(todoNotifierProvider.notifier).fetchCompleteTodos();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final todosValue = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: _appBar(context),
      body: _listView(todosValue),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('History'),
      leading: IconButton(
        onPressed: () async {
          await ref.read(todoNotifierProvider.notifier).fetchIncompleteTodos();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  AsyncValueWidget<List<Todo>> _listView(AsyncValue<List<Todo>> todosValue) {
    return AsyncValueWidget<List<Todo>>(
      value: todosValue,
      data: (todos) {
        return todos.isEmpty
            ? const Center(child: Text('No todos available'))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodosListTile(todo: todo);
                  },
                ),
              );
      },
    );
  }
}
