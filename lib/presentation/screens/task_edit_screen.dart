import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider_setup.dart';
import 'package:uuid/uuid.dart';

class TaskEditScreen extends ConsumerStatefulWidget {
  final Task? task;
  const TaskEditScreen({super.key, this.task});

  @override
  ConsumerState<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends ConsumerState<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;
  int _priority = 1;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _deadlineController = TextEditingController(
      text: widget.task?.deadline.toIso8601String().split('T').first ?? '',
    );
    _priority = widget.task?.priority ?? 1;
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final id = widget.task?.id ?? const Uuid().v4();
      final task = Task(
        id: id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: DateTime.parse(_deadlineController.text.trim()),
        isCompleted: _isCompleted,
        priority: _priority,
        createdBy: '', // Set current user id if available
      );
      try {
        if (widget.task == null) {
          await ref.read(addTaskProvider).call(task);
          if (mounted) Navigator.pop(context, 'added');
        } else {
          await ref.read(updateTaskProvider).call(task);
          if (mounted) Navigator.pop(context, 'updated');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  void _deleteTask() async {
    if (widget.task != null) {
      try {
        await ref.read(deleteTaskProvider).call(widget.task!.id);
        if (mounted) Navigator.pop(context, 'deleted');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Delete error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTask,
              tooltip: 'Delete Task',
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter title'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      maxLines: 2,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter description'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _deadlineController,
                      decoration: InputDecoration(
                        labelText: 'Deadline (YYYY-MM-DD)',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter deadline'
                                  : null,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: widget.task?.deadline ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _deadlineController.text =
                              picked.toIso8601String().split('T').first;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      items:
                          [1, 2, 3, 4, 5]
                              .map(
                                (p) => DropdownMenuItem(
                                  value: p,
                                  child: Text('Priority $p'),
                                ),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _priority = val ?? 1),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _isCompleted,
                      title: const Text('Completed'),
                      secondary: const Icon(Icons.check_circle_outline),
                      onChanged: (val) => setState(() => _isCompleted = val),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveTask,
                      icon: Icon(widget.task == null ? Icons.add : Icons.save),
                      label: Text(
                        widget.task == null ? 'Add Task' : 'Update Task',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
