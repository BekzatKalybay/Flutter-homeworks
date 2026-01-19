class TransactionQuery {
  final String? search;
  final String? categoryId;
  final DateTime? from;
  final DateTime? to;
  final int limit;
  final int offset;

  const TransactionQuery({
    this.search,
    this.categoryId,
    this.from,
    this.to,
    this.limit = 50,
    this.offset = 0,
  });

  TransactionQuery copyWith({
    String? search,
    String? categoryId,
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
  }) {
    return TransactionQuery(
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      from: from ?? this.from,
      to: to ?? this.to,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}
