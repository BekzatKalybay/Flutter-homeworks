import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final List<String> tasks; // Список задач

  TaskListWidget({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task),
          // Дополнительные действия при нажатии на задачу или другие виджеты
        );
      },
    );
  }
}