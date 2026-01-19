import '../../../../core/utils/result.dart';
import '../entities/transaction_entity.dart';
import '../models/transaction_query.dart';
import '../repositories/transactions_repository.dart';

class GetTransactionsUseCase {
  final TransactionsRepository repository;

  const GetTransactionsUseCase(this.repository);

  Future<Result<List<TransactionEntity>>> call(TransactionQuery query) {
    return repository.getTransactions(query);
  }
}
