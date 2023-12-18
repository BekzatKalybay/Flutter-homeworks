import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Управление задачами',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: BlocProvider(
        create: (context) => TaskBloc(),
        child: TaskScreen(),
      ),
    );
  }
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Список задач')),
      body: BlocBuilder<TaskBloc, List<String>>(
        builder: (context, tasks) => ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task),
              onTap: () {
                if (index == 0) {
                  taskBloc.add(TaskEvent.editTask);
                }
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => taskBloc.add(TaskEvent.deleteTask),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          taskBloc.add(TaskEvent.addTask);
        },
        tooltip: 'Добавить задачу',
        child: Icon(Icons.add),
      ),
    );
  }
}
