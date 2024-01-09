import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to Todo App'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Login'))
        ],
      ),
    );
  }
}
