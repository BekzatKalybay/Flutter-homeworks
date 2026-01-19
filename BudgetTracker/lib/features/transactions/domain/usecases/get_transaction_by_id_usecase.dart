import '../../../../core/utils/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transactions_repository.dart';

class GetTransactionByIdUseCase {
  final TransactionsRepository repository;

  const GetTransactionByIdUseCase(this.repository);

  Future<Result<TransactionEntity>> call(String id) {
    return repository.getTransactionById(id);
  }
}
