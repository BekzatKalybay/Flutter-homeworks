import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// События для вашего BLoC
enum TaskEvent { addTask, editTask, deleteTask }

class TaskBloc extends Bloc<TaskEvent, List<String>> {
  TaskBloc() : super([]);

  @override
  Stream<List<String>> mapEventToState(TaskEvent event) async* {
    switch (event) {
      case TaskEvent.addTask:
        final newTask = await _showDialogToAddTask();
        if (newTask != null) {
          yield state + [newTask];
        }
        break;
      case TaskEvent.editTask:
        final editedTask = await _showDialogToEditTask(state.isNotEmpty ? state[0] : '');
        if (editedTask != null) {
          final updatedList = List.from(state);
          updatedList[0] = editedTask;
          yield updatedList;
        }
        break;
      case TaskEvent.deleteTask:
        if (state.isNotEmpty) {
          yield state.sublist(0, state.length - 1);
        }
        break;
    }
  }

  Future<String?> _showDialogToAddTask() {
    TextEditingController taskController = TextEditingController();
    return showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить задачу'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Введите задачу'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, taskController.text);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showDialogToEditTask(String task) {
    TextEditingController taskController = TextEditingController(text: task);
    return showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать задачу'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Введите задачу'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, taskController.text);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
