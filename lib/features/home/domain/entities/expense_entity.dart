class ExpenseEntity {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.date,
  });

  @override
  String toString() =>
      'ExpenseEntity(id: $id, category: $category, amount: $amount)';
}
