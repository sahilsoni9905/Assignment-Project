import '../entities/transaction_entity.dart';

abstract class balancesRepository {
  Future<void> saveItem(String key, dynamic value);
  Future<dynamic> getItem(String key);

  Future<List<TransactionEntity>> getTransactions(String userId);
  Future<void> saveTransaction(TransactionEntity transaction);
}
