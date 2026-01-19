import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/errors/failure.dart';

part 'add_transaction_state.freezed.dart';

@freezed
class AddTransactionState with _$AddTransactionState {
  const factory AddTransactionState.initial() = _Initial;

  const factory AddTransactionState.loading() = _Loading;

  const factory AddTransactionState.success() = _Success;

  const factory AddTransactionState.failure(Failure failure) = _Failure;
}
