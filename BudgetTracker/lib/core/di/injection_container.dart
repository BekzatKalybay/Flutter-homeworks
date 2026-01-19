import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../app/router/app_router.dart';
import '../network/dio_client.dart';
import '../../features/transactions/data/datasources/transactions_fake_remote_datasource.dart';
import '../../features/transactions/data/datasources/transactions_local_datasource.dart';
import '../../features/transactions/data/datasources/transactions_remote_datasource.dart';
import '../../features/transactions/data/repositories/transactions_repository_impl.dart';
import '../../features/transactions/domain/repositories/transactions_repository.dart';
import '../../features/transactions/domain/usecases/delete_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart';
import '../../features/transactions/presentation/bloc/transactions_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Router
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  // Network
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt()));

  // Transactions - Data Sources
  // Use fake remote datasource for MVP (switch to TransactionsRemoteDataSourceImpl for real backend)
  getIt.registerLazySingleton<TransactionsRemoteDataSource>(
    () => TransactionsFakeRemoteDataSource(),
  );
  getIt.registerLazySingleton<TransactionsLocalDataSource>(
    () => TransactionsLocalDataSourceImpl(),
  );

  // Transactions - Repository
  getIt.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Transactions - Use Cases
  getIt.registerLazySingleton<GetTransactionsUseCase>(
    () => GetTransactionsUseCase(getIt()),
  );
  getIt.registerLazySingleton<DeleteTransactionUseCase>(
    () => DeleteTransactionUseCase(getIt()),
  );

  // Transactions - Bloc (factory, not singleton, so each page gets a new instance)
  getIt.registerFactory<TransactionsBloc>(
    () => TransactionsBloc(
      getTransactionsUseCase: getIt(),
      deleteTransactionUseCase: getIt(),
    ),
  );
}
