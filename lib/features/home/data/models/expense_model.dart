import '../../domain/entities/expense_entity.dart';

class ExpenseModel {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final DateTime date;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory ExpenseModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'id': id,
      'userId': userId,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      userId: userId,
      category: category,
      amount: amount,
      date: date,
    );
  }

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      userId: entity.userId,
      category: entity.category,
      amount: entity.amount,
      date: entity.date,
    );
  }
}
