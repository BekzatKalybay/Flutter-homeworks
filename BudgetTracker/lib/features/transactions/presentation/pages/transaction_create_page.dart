import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TransactionCreatePage extends StatelessWidget {
  const TransactionCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: const Center(
        child: Text(
          'Transaction Create Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
