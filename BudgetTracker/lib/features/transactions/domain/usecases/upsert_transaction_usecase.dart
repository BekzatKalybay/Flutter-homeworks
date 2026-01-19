import '../../../../core/utils/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transactions_repository.dart';

class UpsertTransactionUseCase {
  final TransactionsRepository repository;

  const UpsertTransactionUseCase(this.repository);

  Future<Result<void>> call(TransactionEntity transaction) {
    return repository.upsertTransaction(transaction);
  }
}
