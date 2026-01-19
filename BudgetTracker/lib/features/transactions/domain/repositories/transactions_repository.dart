import '../../../../core/utils/result.dart';
import '../entities/transaction_entity.dart';
import '../models/transaction_query.dart';

abstract class TransactionsRepository {
  Future<Result<List<TransactionEntity>>> getTransactions(
    TransactionQuery query,
  );

  Future<Result<TransactionEntity>> getTransactionById(String id);

  Future<Result<void>> upsertTransaction(TransactionEntity transaction);

  Future<Result<void>> deleteTransaction(String id);
}
