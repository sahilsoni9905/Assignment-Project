import '../entities/expense_entity.dart';

abstract class HomeRepository {
  Future<void> saveItem(String key, dynamic value);
  Future<dynamic> getItem(String key);

  Future<List<ExpenseEntity>> getExpenses(String userId);
  Future<void> saveExpense(ExpenseEntity expense);
}
