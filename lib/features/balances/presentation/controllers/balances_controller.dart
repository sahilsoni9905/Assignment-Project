import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/balances_usecase.dart';

class BalancesController extends GetxController {
  final BalancesUseCase _useCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  BalancesController(this._useCase, this._getCurrentUserUseCase);

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxList<TransactionEntity> transactions = <TransactionEntity>[].obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final RxString selectedCategory = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;
  final RxDouble remainingBalance = 0.0.obs;

  final List<CategoryOption> categories = const [
    CategoryOption('Salary', Icons.payments_outlined, Color(0xFF3FB9A2)),
    CategoryOption('Freelance', Icons.work_outline, Color(0xFF5DD7F5)),
    CategoryOption('Food', Icons.fastfood_outlined, Color(0xFFF7C95F)),
    CategoryOption('Shopping', Icons.shopping_bag_outlined, Color(0xFFF06AF7)),
    CategoryOption(
      'Transport',
      Icons.directions_car_outlined,
      Color(0xFFB1E3FF),
    ),
    CategoryOption('Bills', Icons.receipt_long_outlined, Color(0xFFB8B8B8)),
  ];

  @override
  void onInit() {
    super.onInit();
    selectedCategory.value = categories.first.name;
    _loadTransactions();
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }

  Future<void> _loadTransactions() async {
    isLoading.value = true;
    currentUser.value = await _getCurrentUserUseCase();
    final user = currentUser.value;
    if (user != null) {
      transactions.value = await _useCase.getTransactions(user.id);
      await _refreshMonthlySummary();
    }
    isLoading.value = false;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> addIncome() async {
    await _addTransaction(TransactionType.income);
  }

  Future<void> addExpense() async {
    await _addTransaction(TransactionType.expense);
  }

  Future<void> _addTransaction(TransactionType type) async {
    final user = currentUser.value;
    if (user == null) return;

    final amountText = amountController.text.trim();
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      errorMessage.value = 'Enter a valid amount.';
      return;
    }
    if (selectedCategory.value.isEmpty) {
      errorMessage.value = 'Select a category.';
      return;
    }

    errorMessage.value = '';
    isSubmitting.value = true;
    try {
      final transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.id,
        type: type,
        amount: amount,
        category: selectedCategory.value,
        date: selectedDate.value,
        note: noteController.text.trim(),
      );
      await _useCase.addTransaction(transaction);
      transactions.add(transaction);
      await _refreshMonthlySummary();
      amountController.clear();
      noteController.clear();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> _refreshMonthlySummary() async {
    final user = currentUser.value;
    if (user == null) return;
    final summary = await _useCase.getMonthlySummary(user.id, DateTime.now());
    totalIncome.value = summary.totalIncome;
    totalExpense.value = summary.totalExpense;
    remainingBalance.value = summary.remainingBalance;
  }

  Map<String, double> getCategoryTotals(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final totals = <String, double>{};
    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) continue;
      if (transaction.date.isBefore(start) || !transaction.date.isBefore(end)) {
        continue;
      }
      totals.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return totals;
  }
}

class CategoryOption {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryOption(this.name, this.icon, this.color);
}
