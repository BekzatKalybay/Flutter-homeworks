import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/transaction_query.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;

  TransactionQuery _currentQuery = const TransactionQuery();

  TransactionsBloc({
    required this.getTransactionsUseCase,
    required this.deleteTransactionUseCase,
  }) : super(const TransactionsState.initial()) {
    on<TransactionsFetchStarted>(_onFetchStarted);
    on<TransactionsRefreshRequested>(_onRefreshRequested);
    on<TransactionsSearchChanged>(_onSearchChanged);
    on<TransactionsFilterChanged>(_onFilterChanged);
    on<TransactionsDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onFetchStarted(
    TransactionsFetchStarted event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(const TransactionsState.loading());
    await _fetchTransactions(emit);
  }

  Future<void> _onRefreshRequested(
    TransactionsRefreshRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final currentState = state;
    // Keep current state but mark as refreshing if loaded
    if (currentState is TransactionsStateLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(const TransactionsState.loading());
    }
    await _fetchTransactions(emit);
  }

  Future<void> _onSearchChanged(
    TransactionsSearchChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    _currentQuery = _currentQuery.copyWith(
      search: event.search.isEmpty ? null : event.search,
      offset: 0,
    );
    emit(const TransactionsState.loading());
    await _fetchTransactions(emit);
  }

  Future<void> _onFilterChanged(
    TransactionsFilterChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    _currentQuery = _currentQuery.copyWith(
      categoryId: event.categoryId,
      from: event.from,
      to: event.to,
      offset: 0,
    );
    emit(const TransactionsState.loading());
    await _fetchTransactions(emit);
  }

  Future<void> _onDeleteRequested(
    TransactionsDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final result = await deleteTransactionUseCase(event.id);
    result.fold(
      (failure) {
        // Don't change state on delete failure, just log
        // In a real app, you might want to show a snackbar
      },
      (_) async {
        // Refresh the list after successful delete
        await _fetchTransactions(emit);
      },
    );
  }

  Future<void> _fetchTransactions(Emitter<TransactionsState> emit) async {
    final result = await getTransactionsUseCase(_currentQuery);

    result.fold(
      (failure) {
        // Check if we have cached data (offline mode)
        final isOffline = failure is NetworkFailure;
        emit(TransactionsState.failure(
          failure: failure,
          query: _currentQuery,
          isOffline: isOffline,
        ));
      },
      (transactions) {
        final isOffline = false; // If we got data, we're not offline
        if (transactions.isEmpty) {
          emit(TransactionsState.empty(
            query: _currentQuery,
            isOffline: isOffline,
          ));
        } else {
          final currentState = state;
          final isRefreshing = currentState is TransactionsStateLoaded &&
              currentState.isRefreshing;
          emit(TransactionsState.loaded(
            items: transactions,
            query: _currentQuery,
            isOffline: isOffline,
            isRefreshing: isRefreshing,
          ));
        }
      },
    );
  }
}
