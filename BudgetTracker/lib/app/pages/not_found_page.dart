import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.router.pushAndClearStack(const MainTabsRoute());
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
