import '../entities/monthly_summary_entity.dart';
import '../entities/transaction_entity.dart';
import '../repositories/balances_repository.dart';

class BalancesUseCase {
  final balancesRepository _repository;

  BalancesUseCase(this._repository);

  Future<void> saveItem(String key, dynamic value) async {
    await _repository.saveItem(key, value);
  }

  Future<dynamic> getItem(String key) async {
    return _repository.getItem(key);
  }

  Future<List<TransactionEntity>> getTransactions(String userId) async {
    return _repository.getTransactions(userId);
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    await _repository.saveTransaction(transaction);
  }

  Future<MonthlySummaryEntity> getMonthlySummary(
    String userId,
    DateTime month,
  ) async {
    final transactions = await _repository.getTransactions(userId);
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (transaction.date.isBefore(start) || !transaction.date.isBefore(end)) {
        continue;
      }
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return MonthlySummaryEntity(
      totalIncome: income,
      totalExpense: expense,
      remainingBalance: income - expense,
    );
  }

  Future<MonthlySummaryEntity> getAllTimeSummary(String userId) async {
    final transactions = await _repository.getTransactions(userId);
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return MonthlySummaryEntity(
      totalIncome: income,
      totalExpense: expense,
      remainingBalance: income - expense,
    );
  }
}
