import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/feature1_local_data_source.dart';
import '../models/expense_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Feature1LocalDataSource _localDataSource;

  HomeRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveItem(String key, dynamic value) async {
    await _localDataSource.saveData(key, value);
  }

  @override
  Future<dynamic> getItem(String key) async {
    return _localDataSource.getData(key);
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(String userId) async {
    final maps = await _localDataSource.getExpenseMaps(userId);
    return maps.map(ExpenseModel.fromHiveMap).map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> saveExpense(ExpenseEntity expense) async {
    final current = await _localDataSource.getExpenseMaps(expense.userId);
    final updated = [...current, ExpenseModel.fromEntity(expense).toHiveMap()];
    await _localDataSource.saveExpenseMaps(expense.userId, updated);
  }
}
