import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text(
          'Transactions Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(const TransactionCreateRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
