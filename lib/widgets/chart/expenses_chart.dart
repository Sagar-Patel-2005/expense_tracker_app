import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';



class ExpensesChart extends StatelessWidget {
  const ExpensesChart({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  double getTotalForCategory(Category category) {
    return expenses
        .where((expense) => expense.category == category)
        .fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodTotal = getTotalForCategory(Category.food);
    final travelTotal = getTotalForCategory(Category.travel);
    final leisureTotal = getTotalForCategory(Category.leisure);
    final workTotal = getTotalForCategory(Category.work);

    final totalExpense =
        foodTotal + travelTotal + leisureTotal + workTotal;

    if (totalExpense == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Expenses by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 45,
                  sections: [
                    _buildSection(
                      total: foodTotal,
                      totalExpense: totalExpense,
                      color: Colors.orange,
                      title: 'Food',
                    ),
                    _buildSection(
                      total: travelTotal,
                      totalExpense: totalExpense,
                      color: Colors.blue,
                      title: 'Travel',
                    ),
                    _buildSection(
                      total: leisureTotal,
                      totalExpense: totalExpense,
                      color: Colors.purple,
                      title: 'Leisure',
                    ),
                    _buildSection(
                      total: workTotal,
                      totalExpense: totalExpense,
                      color: Colors.green,
                      title: 'Work',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildLegend(
              color: Colors.orange,
              title: 'Food',
              amount: foodTotal,
            ),

            _buildLegend(
              color: Colors.blue,
              title: 'Travel',
              amount: travelTotal,
            ),

            _buildLegend(
              color: Colors.purple,
              title: 'Leisure',
              amount: leisureTotal,
            ),

            _buildLegend(
              color: Colors.green,
              title: 'Work',
              amount: workTotal,
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _buildSection({
    required double total,
    required double totalExpense,
    required Color color,
    required String title,
  }) {
    if (total == 0) {
      return PieChartSectionData(
        value: 0,
        showTitle: false,
      );
    }

    final percentage = (total / totalExpense) * 100;

    return PieChartSectionData(
      value: total,
      color: color,
      radius: 60,
      title: '${percentage.toStringAsFixed(0)}%',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLegend({
    required Color color,
    required String title,
    required double amount,
  }) {
    if (amount == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(title),
          ),

          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}