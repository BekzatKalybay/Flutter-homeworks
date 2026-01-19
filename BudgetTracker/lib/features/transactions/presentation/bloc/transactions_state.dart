import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/models/transaction_query.dart';

part 'transactions_state.freezed.dart';

@freezed
class TransactionsState with _$TransactionsState {
  const factory TransactionsState.initial() = _Initial;

  const factory TransactionsState.loading() = _Loading;

  const factory TransactionsState.loaded({
    required List<TransactionEntity> items,
    required TransactionQuery query,
    required bool isOffline,
    required bool isRefreshing,
  }) = _Loaded;

  const factory TransactionsState.empty({
    required TransactionQuery query,
    required bool isOffline,
  }) = _Empty;

  const factory TransactionsState.failure({
    required Failure failure,
    required TransactionQuery query,
    required bool isOffline,
  }) = _Failure;
}
