import 'package:dio/dio.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/utils/result.dart';
import '../dto/transaction_dto.dart';

abstract class TransactionsRemoteDataSource {
  Future<Result<List<TransactionDto>>> getTransactions({
    String? search,
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  });

  Future<Result<TransactionDto>> getTransactionById(String id);

  Future<Result<TransactionDto>> createTransaction(TransactionDto dto);

  Future<Result<TransactionDto>> updateTransaction(String id, TransactionDto dto);

  Future<Result<void>> deleteTransaction(String id);
}

class TransactionsRemoteDataSourceImpl implements TransactionsRemoteDataSource {
  final Dio dio;

  TransactionsRemoteDataSourceImpl(this.dio);

  @override
  Future<Result<List<TransactionDto>>> getTransactions({
    String? search,
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null) queryParams['search'] = search;
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (from != null) queryParams['from'] = from.toIso8601String();
      if (to != null) queryParams['to'] = to.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await dio.get(
        '/transactions',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? response.data;
      final transactions = data
          .map((json) => TransactionDto.fromJson(json as Map<String, dynamic>))
          .toList();

      return Success(transactions);
    } on DioException catch (e) {
      return FailureResult(ErrorMapper.mapDioException(e));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TransactionDto>> getTransactionById(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      final dto = TransactionDto.fromJson(response.data as Map<String, dynamic>);
      return Success(dto);
    } on DioException catch (e) {
      return FailureResult(ErrorMapper.mapDioException(e));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TransactionDto>> createTransaction(TransactionDto dto) async {
    try {
      final response = await dio.post(
        '/transactions',
        data: dto.toJson(),
      );
      final createdDto = TransactionDto.fromJson(response.data as Map<String, dynamic>);
      return Success(createdDto);
    } on DioException catch (e) {
      return FailureResult(ErrorMapper.mapDioException(e));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TransactionDto>> updateTransaction(String id, TransactionDto dto) async {
    try {
      final response = await dio.put(
        '/transactions/$id',
        data: dto.toJson(),
      );
      final updatedDto = TransactionDto.fromJson(response.data as Map<String, dynamic>);
      return Success(updatedDto);
    } on DioException catch (e) {
      return FailureResult(ErrorMapper.mapDioException(e));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTransaction(String id) async {
    try {
      await dio.delete('/transactions/$id');
      return const Success(null);
    } on DioException catch (e) {
      return FailureResult(ErrorMapper.mapDioException(e));
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
