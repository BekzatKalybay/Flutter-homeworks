import 'dart:async';
import '../../../../core/utils/result.dart';
import 'transactions_remote_datasource.dart';
import '../dto/transaction_dto.dart';

class TransactionsFakeRemoteDataSource implements TransactionsRemoteDataSource {
  // Simulate network delay
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<Result<List<TransactionDto>>> getTransactions({
    String? search,
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    await _delay();

    final mockTransactions = _generateMockTransactions();

    var filtered = mockTransactions;

    // Apply filters
    if (search != null && search.isNotEmpty) {
      filtered = filtered.where((tx) {
        return tx.note?.toLowerCase().contains(search.toLowerCase()) ?? false;
      }).toList();
    }

    if (categoryId != null) {
      filtered = filtered.where((tx) => tx.categoryId == categoryId).toList();
    }

    if (from != null) {
      filtered = filtered.where((tx) => DateTime.parse(tx.date).isAfter(from)).toList();
    }

    if (to != null) {
      filtered = filtered.where((tx) => DateTime.parse(tx.date).isBefore(to)).toList();
    }

    // Apply pagination
    final start = offset ?? 0;
    final end = limit != null ? (start + limit) : filtered.length;
    final paginated = filtered.sublist(
      start.clamp(0, filtered.length),
      end.clamp(0, filtered.length),
    );

    return Success(paginated);
  }

  @override
  Future<Result<TransactionDto>> getTransactionById(String id) async {
    await _delay();

    final mockTransactions = _generateMockTransactions();
    final transaction = mockTransactions.firstWhere(
      (tx) => tx.id == id,
      orElse: () => throw Exception('Transaction not found'),
    );

    return Success(transaction);
  }

  @override
  Future<Result<TransactionDto>> createTransaction(TransactionDto dto) async {
    await _delay();
    // Return the created transaction with a new ID if not provided
    final createdDto = dto.id.isEmpty
        ? TransactionDto(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            amount: dto.amount,
            typeString: dto.typeString,
            categoryId: dto.categoryId,
            date: dto.date,
            note: dto.note,
          )
        : dto;
    return Success(createdDto);
  }

  @override
  Future<Result<TransactionDto>> updateTransaction(String id, TransactionDto dto) async {
    await _delay();
    return Success(dto);
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    await _delay();
    return const Success(null);
  }

  List<TransactionDto> _generateMockTransactions() {
    final now = DateTime.now();
    return [
      TransactionDto(
        id: '1',
        amount: 1500.0,
        typeString: 'income',
        categoryId: 'cat_salary',
        date: now.subtract(const Duration(days: 5)).toIso8601String(),
        note: 'Monthly salary',
      ),
      TransactionDto(
        id: '2',
        amount: 45.50,
        typeString: 'expense',
        categoryId: 'cat_food',
        date: now.subtract(const Duration(days: 3)).toIso8601String(),
        note: 'Grocery shopping',
      ),
      TransactionDto(
        id: '3',
        amount: 120.0,
        typeString: 'expense',
        categoryId: 'cat_transport',
        date: now.subtract(const Duration(days: 2)).toIso8601String(),
        note: 'Gas station',
      ),
      TransactionDto(
        id: '4',
        amount: 25.99,
        typeString: 'expense',
        categoryId: 'cat_food',
        date: now.subtract(const Duration(days: 1)).toIso8601String(),
        note: 'Restaurant lunch',
      ),
      TransactionDto(
        id: '5',
        amount: 300.0,
        typeString: 'income',
        categoryId: 'cat_freelance',
        date: now.toIso8601String(),
        note: 'Freelance project payment',
      ),
    ];
  }
}
