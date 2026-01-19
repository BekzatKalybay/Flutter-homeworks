import '../errors/failure.dart';

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(:final data) => data,
        FailureResult<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final failure) => failure,
      };

  Result<R> map<R>(R Function(T) mapper) => switch (this) {
        Success<T>(:final data) => Success(mapper(data)),
        FailureResult<T>(:final failure) => FailureResult(failure),
      };

  Result<R> flatMap<R>(Result<R> Function(T) mapper) => switch (this) {
        Success<T>(:final data) => mapper(data),
        FailureResult<T>(:final failure) => FailureResult(failure),
      };

  R fold<R>(R Function(Failure) onFailure, R Function(T) onSuccess) => switch (this) {
        Success<T>(:final data) => onSuccess(data),
        FailureResult<T>(:final failure) => onFailure(failure),
      };
}
