import '../../../../core/utils/result.dart';
import '../repositories/transactions_repository.dart';

class DeleteTransactionUseCase {
  final TransactionsRepository repository;

  const DeleteTransactionUseCase(this.repository);

  Future<Result<void>> call(String id) {
    return repository.deleteTransaction(id);
  }
}
