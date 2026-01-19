import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/types/transaction_type.dart';
import '../../domain/usecases/upsert_transaction_usecase.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final UpsertTransactionUseCase upsertTransactionUseCase;

  AddTransactionCubit({
    required this.upsertTransactionUseCase,
  }) : super(const AddTransactionState.initial());

  Future<void> submitTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    emit(const AddTransactionState.loading());

    final transaction = TransactionEntity(
      id: '', // Empty ID means create new
      amount: amount,
      type: type,
      categoryId: categoryId,
      date: date,
      note: note,
    );

    final result = await upsertTransactionUseCase(transaction);

    result.fold(
      (failure) => emit(AddTransactionState.failure(failure)),
      (_) => emit(const AddTransactionState.success()),
    );
  }
}
