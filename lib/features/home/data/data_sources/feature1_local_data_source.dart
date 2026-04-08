import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

abstract class Feature1LocalDataSource {
  Future<void> saveData(String key, dynamic value);
  Future<dynamic> getData(String key);
  Future<List<Map<dynamic, dynamic>>> getExpenseMaps(String userId);
  Future<void> saveExpenseMaps(String userId, List<Map<dynamic, dynamic>> data);
}

class Feature1LocalDataSourceImpl implements Feature1LocalDataSource {
  Box get _box => Hive.box(AppConstants.feature1Box);

  String _expenseKey(String userId) => 'expenses_$userId';

  @override
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  Future<dynamic> getData(String key) async {
    return _box.get(key);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> getExpenseMaps(String userId) async {
    final raw = _box.get(_expenseKey(userId));
    if (raw == null) return [];
    return (raw as List).cast<Map>();
  }

  @override
  Future<void> saveExpenseMaps(
    String userId,
    List<Map<dynamic, dynamic>> data,
  ) async {
    await _box.put(_expenseKey(userId), data);
  }
}
