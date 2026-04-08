import '../entities/expense_entity.dart';
import '../repositories/home_repository.dart';

class HomeUseCase {
  final HomeRepository _repository;

  HomeUseCase(this._repository);

  Future<void> saveItem(String key, dynamic value) async {
    await _repository.saveItem(key, value);
  }

  Future<dynamic> getItem(String key) async {
    return _repository.getItem(key);
  }

  Future<List<ExpenseEntity>> getExpenses(String userId) async {
    return _repository.getExpenses(userId);
  }

  Future<void> saveExpense(ExpenseEntity expense) async {
    await _repository.saveExpense(expense);
  }
}
