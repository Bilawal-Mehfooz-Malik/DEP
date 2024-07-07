import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

import '../model/todo.dart';
import 'custom_textformfield.dart';
import '../utils/date_formatter.dart';

class AddUpDateTodoScreen extends StatefulWidget {
  final String title;
  final Todo? todo;
  final String buttonText;
  final Function(Todo) onSubmit;

  const AddUpDateTodoScreen({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSubmit,
    required this.todo,
  });

  @override
  State<AddUpDateTodoScreen> createState() => _AddUpDateTodoScreenState();
}

class _AddUpDateTodoScreenState extends State<AddUpDateTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _dueDate;
  String _category = 'Personal';

  @override
  void initState() {
    if (widget.todo != null) {
      final todo = widget.todo!;
      _titleController.text = todo.title;
      _descController.text = todo.description;
      _dueDate = todo.dueDate;
      _category = todo.category;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // [Save Todo]
  void _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      final todo = Todo(
        id: widget.todo?.id ?? -1,
        title: _titleController.text,
        description: _descController.text,
        category: _category,
        dueDate: _dueDate ?? DateTime.now(),
      );

      widget.onSubmit(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: style.textTheme.titleLarge),
                const Gap(16),
                _buildTitleField(),
                const Gap(24),
                _buildDescriptionField(),
                const Gap(16),
                _buildCategoryAndDateRow(),
                const Gap(32),
                _buildSaveButton(),
                const Gap(16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return CustomTextFormField(
      hintText: 'Title',
      controller: _titleController,
      emptyMessage: 'Please enter a title',
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        maxLines: 5,
        controller: _descController,
        decoration: const InputDecoration(
          hintText: 'Description',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategoryAndDateRow() {
    return Row(
      children: [
        Expanded(child: _buildCategoryDropdown()),
        const Gap(16),
        Expanded(child: _buildDueDatePicker()),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField(
      value: _category,
      items: _categoryItems,
      onChanged: (value) {
        setState(() {
          _category = value!;
        });
      },
      decoration: const InputDecoration(labelText: 'Category'),
    );
  }

  Widget _buildDueDatePicker() {
    return InkWell(
      onTap: _showDatePicker,
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Due Date'),
        child: Text(
          _dueDate == null ? 'Select Date' : formatDate(_dueDate!),
        ),
      ),
    );
  }

  // [Show Date Picker]
  Future<void> _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveTodo,
        child: Text(widget.buttonText),
      ),
    );
  }

  List<DropdownMenuItem<String>> get _categoryItems {
    return const [
      DropdownMenuItem(value: 'Personal', child: Text('Personal')),
      DropdownMenuItem(value: 'Work', child: Text('Work')),
      DropdownMenuItem(value: 'Home', child: Text('Home')),
      DropdownMenuItem(value: 'Health', child: Text('Health')),
      DropdownMenuItem(value: 'Finance', child: Text('Finance')),
      DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
    ];
  }
}
