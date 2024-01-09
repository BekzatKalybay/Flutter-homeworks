import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/localization_bloc.dart';
import '../widgets/task_list_widget.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Список задач')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<LocalizationBloc>(context).add('change_to_russian');
            },
            child: Text('Сменить на русский'),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<LocalizationBloc>(context).add('change_to_english');
            },
            child: Text('Change to English'),
          ),
          TaskListWidget(),
        ],
      ),
    );
  }
}