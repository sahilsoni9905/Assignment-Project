import 'package:get/get.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/expense_entity.dart';
import '../../../auth/domain/usecases/auth_usecases.dart';
import '../../domain/usecases/home_usecase.dart';

class HomeController extends GetxController {
  final HomeUseCase _useCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  HomeController(this._useCase, this._getCurrentUserUseCase);

  final RxBool isLoading = false.obs;
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  final RxBool isWeeklySelected = true.obs;
  final RxList<ExpenseEntity> expenses = <ExpenseEntity>[].obs;

  List<ExpenseEntity> get filteredExpenses {
    final now = DateTime.now();
    if (isWeeklySelected.value) {
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));
      return expenses
          .where((expense) => !expense.date.isBefore(start))
          .toList();
    }
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    return expenses
        .where(
          (expense) =>
              !expense.date.isBefore(start) && expense.date.isBefore(end),
        )
        .toList();
  }

  void selectWeekly() {
    isWeeklySelected.value = true;
  }

  void selectMonthly() {
    isWeeklySelected.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    isLoading.value = true;
    currentUser.value = await _getCurrentUserUseCase();
    if (currentUser.value != null) {
      expenses.value = await _useCase.getExpenses(currentUser.value!.id);
    }
    isLoading.value = false;
  }

  Future<void> addExpense({
    required String category,
    required double amount,
    required DateTime date,
  }) async {
    final user = currentUser.value;
    if (user == null) return;
    final expense = ExpenseEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      category: category,
      amount: amount,
      date: date,
    );
    await _useCase.saveExpense(expense);
    expenses.add(expense);
  }
}
