enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });
}
