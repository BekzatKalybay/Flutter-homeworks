import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainTabsPage extends StatelessWidget {
  const MainTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        TransactionsTab(),
        CategoriesTab(),
        SettingsTab(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
