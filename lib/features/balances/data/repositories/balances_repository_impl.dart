import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/balances_repository.dart';
import '../data_sources/balances_local_data_source.dart';
import '../models/transaction_model.dart';

class BalancesRepositoryImpl implements balancesRepository {
  final BalancesLocalDataSource _localDataSource;

  BalancesRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveItem(String key, dynamic value) async {
    await _localDataSource.saveData(key, value);
  }

  @override
  Future<dynamic> getItem(String key) async {
    return _localDataSource.getData(key);
  }

  @override
  Future<List<TransactionEntity>> getTransactions(String userId) async {
    final maps = await _localDataSource.getTransactionMaps(userId);
    return maps
        .map(TransactionModel.fromHiveMap)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final current = await _localDataSource.getTransactionMaps(
      transaction.userId,
    );
    final updated = [
      ...current,
      TransactionModel.fromEntity(transaction).toHiveMap(),
    ];
    await _localDataSource.saveTransactionMaps(transaction.userId, updated);
  }
}
