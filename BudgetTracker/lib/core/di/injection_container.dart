import 'package:get_it/get_it.dart';
import '../../app/router/app_router.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());
}
