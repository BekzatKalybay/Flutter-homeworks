import 'package:auto_route/auto_route.dart';
import '../../app/pages/main_tabs_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/transactions/presentation/pages/transaction_create_page.dart';
import '../../features/transactions/presentation/pages/transaction_details_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../app/pages/not_found_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: MainTabsRoute.page,
          initial: true,
          children: [
            AutoRoute(
              path: '/transactions',
              page: TransactionsTab.page,
              initial: true,
            ),
            AutoRoute(
              path: '/categories',
              page: CategoriesTab.page,
            ),
            AutoRoute(
              path: '/settings',
              page: SettingsTab.page,
            ),
          ],
        ),
        AutoRoute(
          path: '/transactions/new',
          page: TransactionCreateRoute.page,
        ),
        AutoRoute(
          path: '/transactions/:id',
          page: TransactionDetailsRoute.page,
        ),
        AutoRoute(
          path: '*',
          page: NotFoundRoute.page,
        ),
      ];
}
