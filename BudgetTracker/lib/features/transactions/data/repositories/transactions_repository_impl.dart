import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/models/transaction_query.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_local_datasource.dart';
import '../datasources/transactions_remote_datasource.dart';
import '../dto/transaction_dto.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource remoteDataSource;
  final TransactionsLocalDataSource localDataSource;

  TransactionsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<List<TransactionEntity>>> getTransactions(
    TransactionQuery query,
  ) async {
    // First, try to get cached data
    final cachedResult = await localDataSource.getTransactions();
    final cachedTransactions = cachedResult.dataOrNull ?? [];

    // Try to fetch from remote
    final remoteResult = await remoteDataSource.getTransactions(
      search: query.search,
      categoryId: query.categoryId,
      from: query.from,
      to: query.to,
      limit: query.limit,
      offset: query.offset,
    );

    return remoteResult.fold(
      (failure) {
        // If remote fails, return cached data if available
        if (cachedTransactions.isNotEmpty) {
          // Apply filters to cached data
          var filtered = cachedTransactions;
          if (query.search != null && query.search!.isNotEmpty) {
            filtered = filtered
                .where((tx) =>
                    tx.note?.toLowerCase().contains(query.search!.toLowerCase()) ?? false)
                .toList();
          }
          if (query.categoryId != null) {
            filtered = filtered.where((tx) => tx.categoryId == query.categoryId).toList();
          }
          if (query.from != null) {
            filtered = filtered
                .where((tx) => DateTime.parse(tx.date).isAfter(query.from!))
                .toList();
          }
          if (query.to != null) {
            filtered = filtered
                .where((tx) => DateTime.parse(tx.date).isBefore(query.to!))
                .toList();
          }
          // Apply pagination
          final start = query.offset;
          final end = start + query.limit;
          filtered = filtered.sublist(
            start.clamp(0, filtered.length),
            end.clamp(0, filtered.length),
          );

          return Success(filtered.map((dto) => dto.toEntity()).toList());
        }
        // No cached data, return failure
        return FailureResult(failure);
      },
      (remoteTransactions) async {
        // Remote succeeded, update cache
        await localDataSource.saveTransactions(remoteTransactions);
        // Remote already applied filters and pagination
        return Success(remoteTransactions.map((dto) => dto.toEntity()).toList());
      },
    );
  }

  @override
  Future<Result<TransactionEntity>> getTransactionById(String id) async {
    // Try cache first
    final cachedResult = await localDataSource.getTransactionById(id);
    if (cachedResult.isSuccess && cachedResult.dataOrNull != null) {
      return Success(cachedResult.dataOrNull!.toEntity());
    }

    // Try remote
    final remoteResult = await remoteDataSource.getTransactionById(id);
    return remoteResult.fold(
      (failure) => FailureResult(failure),
      (dto) async {
        // Save to cache
        await localDataSource.saveTransaction(dto);
        return Success(dto.toEntity());
      },
    );
  }

  @override
  Future<Result<void>> upsertTransaction(TransactionEntity transaction) async {
    final dto = TransactionDto.fromEntity(transaction);

    // Try remote first
    final remoteResult = transaction.id.isEmpty
        ? await remoteDataSource.createTransaction(dto)
        : await remoteDataSource.updateTransaction(transaction.id, dto);

    return remoteResult.fold(
      (failure) => FailureResult(failure),
      (savedDto) async {
        // Update cache
        await localDataSource.saveTransaction(savedDto);
        return const Success(null);
      },
    );
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    // Try remote first
    final remoteResult = await remoteDataSource.deleteTransaction(id);

    return remoteResult.fold(
      (failure) => FailureResult(failure),
      (_) async {
        // Remove from cache
        await localDataSource.deleteTransaction(id);
        return const Success(null);
      },
    );
  }
}
