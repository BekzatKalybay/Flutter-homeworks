import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TransactionDetailsPage extends StatelessWidget {
  final String id;

  const TransactionDetailsPage({
    @PathParam('id') required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Transaction Details Page',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Transaction ID: $id',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
