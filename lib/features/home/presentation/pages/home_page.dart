import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tuff_project/common_widgets/top_appbar.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import 'package:tuff_project/features/balances/domain/entities/transaction_entity.dart';
import 'package:tuff_project/features/balances/presentation/controllers/balances_controller.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50.h,
        width: 50.h,
        child: FloatingActionButton(
          onPressed: () => _showAddExpenseSheet(context),
          backgroundColor: AppConstants.whiteColor,
          child: const Icon(Icons.add, color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.currentUser.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              TopAppbar(),
              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, ${controller.currentUser?.value?.name ?? 'User'}!',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add you yeterday’s expense',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              buildCreditCard(),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Your expenses',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              buildSwitchContainerBetweenWeeklyAndMonthly(),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  final balancesController = Get.find<BalancesController>();
                  final items = _buildCategoryTotals(
                    balancesController.transactions,
                    balancesController.categories,
                    controller.isWeeklySelected.value,
                  );
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No expenses yet',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.greyColor,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final expense = items[index];
                      return buildExpenseContainer(
                        category: expense.category,
                        amount: expense.amount.toStringAsFixed(2),
                        icon: expense.icon,
                        accentColor: expense.color,
                      );
                    },
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildCreditCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      height: 218.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFED4B4), Color(0xFF3BB9A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ADRBank',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.whiteColor,
                  ),
                ),
                Image.asset(
                  AppConstants.logoPrimary,
                  height: 24.h,
                  width: 24.h
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1234 1234 1234 1234',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.whiteColor,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Card Holder Name',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                    Text(
                      'Expired Date',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      controller.currentUser?.value?.name ?? 'User',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                    Text(
                      '10/28',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget buildSwitchContainerBetweenWeeklyAndMonthly() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      height: 36.h,
      decoration: BoxDecoration(
        color: Color(0xFF262626),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: buildHelperContainer(
                title: 'Weekly',
                isSelected: controller.isWeeklySelected.value,
                onTap: controller.selectWeekly,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: buildHelperContainer(
                title: 'Monthly',
                isSelected: !controller.isWeeklySelected.value,
                onTap: controller.selectMonthly,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildHelperContainer({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 29.h,
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.whiteColor : null,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : AppConstants.greyColor,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddExpenseSheet(BuildContext context) async {
    final balancesController = Get.find<BalancesController>();
    final categories = balancesController.categories
        .map((category) => category.name)
        .toList();
    final category = categories.first.obs;
    final dateValue = DateTime.now().obs;
    final transactionType = TransactionType.expense.obs;
    balancesController.selectCategory(category.value);
    balancesController.selectDate(dateValue.value);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, bottomInset + 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppConstants.greyColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Obx(() {
                final isIncome =
                    transactionType.value == TransactionType.income;
                return Text(
                  isIncome ? 'Add income' : 'Add expense',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.whiteColor,
                  ),
                );
              }),
              SizedBox(height: 12.h),
              Container(
                height: 34.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Obx(() {
                  final isIncome =
                      transactionType.value == TransactionType.income;
                  return Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              transactionType.value = TransactionType.expense,
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: !isIncome ? AppConstants.whiteColor : null,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: !isIncome
                                      ? Colors.black
                                      : AppConstants.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: InkWell(
                          onTap: () =>
                              transactionType.value = TransactionType.income,
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: isIncome ? AppConstants.whiteColor : null,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Center(
                              child: Text(
                                'Income',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isIncome
                                      ? Colors.black
                                      : AppConstants.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 16.h),
              Text(
                'Category',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
              SizedBox(height: 6.h),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: category.value,
                  dropdownColor: const Color(0xFF1F1F1F),
                  decoration: _sheetFieldDecoration('Select category'),
                  items: categories
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: AppConstants.whiteColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      category.value = value;
                      balancesController.selectCategory(value);
                    }
                  },
                );
              }),
              SizedBox(height: 12.h),
              Text(
                'Amount',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
              SizedBox(height: 6.h),
              TextFormField(
                controller: balancesController.amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
                decoration: _sheetFieldDecoration('Enter amount'),
              ),
              SizedBox(height: 12.h),
              Text(
                'Date',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
              SizedBox(height: 6.h),
              Obx(() {
                final label =
                    '${dateValue.value.day}/${dateValue.value.month}/${dateValue.value.year}';
                return InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: dateValue.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) dateValue.value = picked;
                    balancesController.selectDate(dateValue.value);
                  },
                  child: InputDecorator(
                    decoration: _sheetFieldDecoration('Select date'),
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h),
              Text(
                'Note',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
              SizedBox(height: 6.h),
              TextFormField(
                controller: balancesController.noteController,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
                decoration: _sheetFieldDecoration('Add a note'),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 44.h,
                child: ElevatedButton(
                  onPressed: () {
                    final rawAmount = balancesController.amountController.text
                        .trim();
                    final parsedAmount = double.tryParse(rawAmount);
                    if (parsedAmount == null || parsedAmount <= 0) {
                      Get.snackbar('Invalid amount', 'Enter a valid amount.');
                      return;
                    }
                    balancesController.selectCategory(category.value);
                    balancesController.selectDate(dateValue.value);
                    if (transactionType.value == TransactionType.income) {
                      balancesController.addIncome();
                    } else {
                      balancesController.addExpense();
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.whiteColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _sheetFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppConstants.greyColor.withOpacity(0.7),
      ),
      filled: true,
      fillColor: const Color(0xFF262626),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppConstants.whiteColor.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }

  List<_CategorySpend> _buildCategoryTotals(
    List<TransactionEntity> transactions,
    List<CategoryOption> categories,
    bool isWeeklySelected,
  ) {
    final now = DateTime.now();
    final start = isWeeklySelected
        ? DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(const Duration(days: 6))
        : DateTime(now.year, now.month, 1);
    final end = isWeeklySelected
        ? DateTime(now.year, now.month, now.day + 1)
        : DateTime(now.year, now.month + 1, 1);

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

    final items = <_CategorySpend>[];
    for (final category in categories) {
      final value = totals[category.name];
      if (value == null || value <= 0) continue;
      items.add(
        _CategorySpend(
          category: category.name,
          amount: value,
          icon: category.icon,
          color: category.color,
        ),
      );
    }

    items.sort((a, b) => b.amount.compareTo(a.amount));
    return items;
  }

  Widget buildExpenseContainer({
    required String category,
    required String amount,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      height: 85.h,
      decoration: inset.BoxDecoration(
        border: Border.all(color: const Color(0xFF262626), width: 0.53),
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF262626), Color(0xFF0A0A0A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          inset.BoxShadow(
            color: const Color(0xFFFAFAFA).withOpacity(0.15),
            blurRadius: 7,
            offset: const Offset(2, 2),
            inset: true,
          ),
          inset.BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            blurRadius: 7,
            offset: const Offset(-2, -2),
            inset: true,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 34.h,
            width: 34.h,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Image.asset(AppConstants.logoPrimary),
          ),
          SizedBox(width: 12.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
              Text(
                controller.isWeeklySelected.value
                    ? 'Expense in this week'
                    : 'Expense this month',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.greyColor,
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.star_border_outlined,
            color: AppConstants.greyColor,
            size: 22.sp,
          ),
          SizedBox(width: 12.w),
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                '\$ $amount',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySpend {
  final String category;
  final double amount;
  final IconData icon;
  final Color color;

  const _CategorySpend({
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
  });
}
