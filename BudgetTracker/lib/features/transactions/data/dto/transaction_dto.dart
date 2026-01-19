import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/types/transaction_type.dart';

part 'transaction_dto.g.dart';

@JsonSerializable()
class TransactionDto {
  final String id;
  final double amount;
  @JsonKey(name: 'type')
  final String typeString;
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String date;
  final String? note;

  const TransactionDto({
    required this.id,
    required this.amount,
    required this.typeString,
    required this.categoryId,
    required this.date,
    this.note,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDtoToJson(this);

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      type: typeString == 'income' ? TransactionType.income : TransactionType.expense,
      categoryId: categoryId,
      date: DateTime.parse(date),
      note: note,
    );
  }

  factory TransactionDto.fromEntity(TransactionEntity entity) {
    return TransactionDto(
      id: entity.id,
      amount: entity.amount,
      typeString: entity.type == TransactionType.income ? 'income' : 'expense',
      categoryId: entity.categoryId,
      date: entity.date.toIso8601String(),
      note: entity.note,
    );
  }
}
