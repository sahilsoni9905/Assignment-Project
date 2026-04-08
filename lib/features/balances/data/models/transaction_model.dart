import '../../domain/entities/transaction_entity.dart';

class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  factory TransactionModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: (map['type'] as String) == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      note: (map['note'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      userId: userId,
      type: type,
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      amount: entity.amount,
      category: entity.category,
      date: entity.date,
      note: entity.note,
    );
  }
}
