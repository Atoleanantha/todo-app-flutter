
import 'package:flutter/material.dart';

class AddTodoBottomSheet extends StatefulWidget {

  final Function(String, String, bool, bool) onAdd;

  AddTodoBottomSheet({required this.onAdd});

  @override
  _AddTodoBottomSheetState createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPriority = false;
  bool _isCompleted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      widget.onAdd(title, description, _isPriority, _isCompleted);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          CheckboxListTile(
            title: const Text('Priority Task'),
            value: _isPriority,
            onChanged: (value) {
              setState(() {
                _isPriority = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Completed'),
            value: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value ?? false;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _addTask,
                child: Text('Add Task'),
              ),
            ],
          ),
          // const Expanded(child: Text(""))
        ],
      ),
    );
  }
}
