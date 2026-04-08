import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';

abstract class BalancesLocalDataSource {
  Future<void> saveData(String key, dynamic value);
  Future<dynamic> getData(String key);
  Future<List<Map<dynamic, dynamic>>> getTransactionMaps(String userId);
  Future<void> saveTransactionMaps(
    String userId,
    List<Map<dynamic, dynamic>> data,
  );
}

class BalancesLocalDataSourceImpl implements BalancesLocalDataSource {
  Box get _box => Hive.box(AppConstants.feature2Box);

  String _transactionKey(String userId) => 'transactions_$userId';

  @override
  Future<void> saveData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  Future<dynamic> getData(String key) async {
    return _box.get(key);
  }

  @override
  Future<List<Map<dynamic, dynamic>>> getTransactionMaps(String userId) async {
    final raw = _box.get(_transactionKey(userId));
    if (raw == null) return [];
    return (raw as List).cast<Map>();
  }

  @override
  Future<void> saveTransactionMaps(
    String userId,
    List<Map<dynamic, dynamic>> data,
  ) async {
    await _box.put(_transactionKey(userId), data);
  }
}
