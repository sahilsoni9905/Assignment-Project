import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuff_project/common_widgets/top_appbar.dart';
import 'package:tuff_project/core/constants/app_constants.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/balances_controller.dart';

class balancesPage extends GetView<BalancesController> {
  const balancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 50.h,
        width: 50.h,
        child: FloatingActionButton(
          onPressed: () => _showAddTransactionSheet(context),
          backgroundColor: AppConstants.whiteColor,
          child: const Icon(Icons.add, color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopAppbar(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  'Your Balances',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  'Manage your multi-currency accounts',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppConstants.greyColor,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: _buildAnimatedSection(child: _buildScoreCard()),
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  'Available Currencies',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              buildCurrencyContainer(category: 'USD', amount: '\$1,250.00'),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: _buildAnimatedSection(child: _buildSpendingChart()),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current margin: April Spendings',
                      style: GoogleFonts.inter(
                        fontSize: 12.24.sp,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final offset = 16.h * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, offset), child: child),
        );
      },
      onEnd: () {},
    );
  }

  Widget _buildScoreCard() {
    return Obx(() {
      final income = controller.totalIncome.value;
      final expense = controller.totalExpense.value;
      final balance = controller.remainingBalance.value;
      final totals = controller.getCategoryTotals(DateTime.now());

      return Column(
        children: [
          Stack(
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.55,
                  child: SizedBox(
                    height: 240.h,
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: 180,
                        sectionsSpace: 3.r,
                        centerSpaceRadius: 100.r,
                        sections: _buildScoreSections(totals),
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 1000),
                      swapAnimationCurve: Curves.easeOutCubic,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatCurrency(balance),
                      style: GoogleFonts.inter(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remaining balance this month',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.whiteColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Income ${_formatCurrency(income)} · Expense ${_formatCurrency(expense)}',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.greyColor,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  List<PieChartSectionData> _buildScoreSections(Map<String, double> totals) {
    final totalValue = totals.values.fold<double>(0, (sum, v) => sum + v);
    final sections = <PieChartSectionData>[];

    if (totalValue <= 0) {
      sections.add(
        PieChartSectionData(
          value: 1,
          title: '',
          radius: 18.r,
          color: const Color(0xFF2A2A2A),
        ),
      );
      return sections;
    }

    for (final category in controller.categories) {
      final value = totals[category.name];
      if (value == null || value <= 0) continue;
      sections.add(
        PieChartSectionData(
          value: value,
          title: '',
          radius: 18.r,
          color: category.color,
        ),
      );
    }

    return sections;
  }

  Widget _buildSpendingChart() {
    return Obx(() {
      final data = _buildMonthlyExpenseSeries();
      final maxValue = data
          .map((item) => item.value)
          .fold<double>(0, (max, value) => value > max ? value : max);
      final chartMax = maxValue <= 0 ? 100.0 : (maxValue * 1.2).toDouble();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 128.h,
              child: BarChart(
                BarChartData(
                  maxY: chartMax,
                  minY: 0,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24.w,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.inter(
                              color: const Color(0xFF464646),
                              fontSize: 8.74.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: List.generate(data.length, (index) {
                    final item = data[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.value,
                          width: 23.6.w,
                          borderRadius: BorderRadius.circular(3.5.r),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3FB9A2), Color(0xFFF6D2B3)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: chartMax,
                            color: const Color(0xFF1E1E1E),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                swapAnimationDuration: const Duration(milliseconds: 700),
                swapAnimationCurve: Curves.easeOutCubic,
              ),
            ),
          ],
        ),
      );
    });
  }

  List<_MonthlySpend> _buildMonthlyExpenseSeries({int months = 6}) {
    final now = DateTime.now();
    final items = <_MonthlySpend>[];
    for (var i = months - 1; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 1);
      double total = 0;
      for (final transaction in controller.transactions) {
        if (transaction.type != TransactionType.expense) continue;
        if (transaction.date.isBefore(start) ||
            !transaction.date.isBefore(end)) {
          continue;
        }
        total += transaction.amount;
      }
      items.add(_MonthlySpend(_monthLabel(month.month), total));
    }
    return items;
  }

  String _monthLabel(int month) {
    const labels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return labels[month - 1];
  }

  String _formatCurrency(double value) {
    final fixed = value.toStringAsFixed(0);
    return '\$$fixed';
  }

  Widget buildCurrencyContainer({
    required String category,
    required String amount,
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
          Container(height: 24.h, width: 24.h, color: Colors.grey),
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
                'Lesser than last week',
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
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTransactionSheet(BuildContext context) async {
    final categories = controller.categories
        .map((category) => category.name)
        .toList();
    final category = categories.first.obs;
    final dateValue = DateTime.now().obs;
    final transactionType = TransactionType.expense.obs;
    controller.selectCategory(category.value);
    controller.selectDate(dateValue.value);

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
                      controller.selectCategory(value);
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
                controller: controller.amountController,
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
                    controller.selectDate(dateValue.value);
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
                controller: controller.noteController,
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
                    final rawAmount = controller.amountController.text.trim();
                    final parsedAmount = double.tryParse(rawAmount);
                    if (parsedAmount == null || parsedAmount <= 0) {
                      Get.snackbar('Invalid amount', 'Enter a valid amount.');
                      return;
                    }
                    controller.selectCategory(category.value);
                    controller.selectDate(dateValue.value);
                    if (transactionType.value == TransactionType.income) {
                      controller.addIncome();
                    } else {
                      controller.addExpense();
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
}

class _MonthlySpend {
  final String label;
  final double value;

  const _MonthlySpend(this.label, this.value);
}
