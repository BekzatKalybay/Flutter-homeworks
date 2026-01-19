import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../dto/transaction_dto.dart';

abstract class TransactionsLocalDataSource {
  Future<Result<List<TransactionDto>>> getTransactions();
  Future<Result<TransactionDto?>> getTransactionById(String id);
  Future<Result<void>> saveTransactions(List<TransactionDto> transactions);
  Future<Result<void>> saveTransaction(TransactionDto transaction);
  Future<Result<void>> deleteTransaction(String id);
  Future<Result<void>> clearAll();
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  static const String _boxName = 'transactions';
  Box<String>? _box;

  Future<Box<String>> get box async {
    _box ??= await Hive.openBox<String>(_boxName);
    return _box!;
  }

  @override
  Future<Result<List<TransactionDto>>> getTransactions() async {
    try {
      final transactionsBox = await box;
      final transactions = transactionsBox.values
          .map((jsonString) => TransactionDto.fromJson(
                jsonDecode(jsonString) as Map<String, dynamic>,
              ))
          .toList();
      return Success(transactions);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to load transactions from cache: $e'));
    }
  }

  @override
  Future<Result<TransactionDto?>> getTransactionById(String id) async {
    try {
      final transactionsBox = await box;
      final jsonString = transactionsBox.get(id);
      if (jsonString == null) {
        return const Success(null);
      }
      final dto = TransactionDto.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
      return Success(dto);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to load transaction from cache: $e'));
    }
  }

  @override
  Future<Result<void>> saveTransactions(List<TransactionDto> transactions) async {
    try {
      final transactionsBox = await box;
      final Map<String, String> data = {};
      for (final transaction in transactions) {
        data[transaction.id] = jsonEncode(transaction.toJson());
      }
      await transactionsBox.putAll(data);
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to save transactions to cache: $e'));
    }
  }

  @override
  Future<Result<void>> saveTransaction(TransactionDto transaction) async {
    try {
      final transactionsBox = await box;
      await transactionsBox.put(
        transaction.id,
        jsonEncode(transaction.toJson()),
      );
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to save transaction to cache: $e'));
    }
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    try {
      final transactionsBox = await box;
      await transactionsBox.delete(id);
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to delete transaction from cache: $e'));
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      final transactionsBox = await box;
      await transactionsBox.clear();
      return const Success(null);
    } catch (e) {
      return FailureResult(CacheFailure('Failed to clear cache: $e'));
    }
  }
}
