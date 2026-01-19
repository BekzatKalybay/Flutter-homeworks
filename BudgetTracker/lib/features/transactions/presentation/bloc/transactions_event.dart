import 'package:equatable/equatable.dart';
import '../../domain/models/transaction_query.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsFetchStarted extends TransactionsEvent {
  const TransactionsFetchStarted();
}

class TransactionsRefreshRequested extends TransactionsEvent {
  const TransactionsRefreshRequested();
}

class TransactionsSearchChanged extends TransactionsEvent {
  final String search;

  const TransactionsSearchChanged(this.search);

  @override
  List<Object?> get props => [search];
}

class TransactionsFilterChanged extends TransactionsEvent {
  final String? categoryId;
  final DateTime? from;
  final DateTime? to;

  const TransactionsFilterChanged({
    this.categoryId,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [categoryId, from, to];
}

class TransactionsDeleteRequested extends TransactionsEvent {
  final String id;

  const TransactionsDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
