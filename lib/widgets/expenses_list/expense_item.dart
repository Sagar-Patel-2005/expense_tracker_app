import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget{
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.tital, style: Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 5,),
          Row(
            children: [
              Text("₹ ${expense.amount.toStringAsFixed(2)}",), // For understanding ("\$ ${expense.amount.toStringAsFixed(2)}"),
              const Spacer(),
              Row(
                children: [
                  Icon(categoryIcons[expense.category]),
                  const SizedBox(width: 8,),
                  Text(expense.formatteddate,),
                ],
              ),
            ],
          ),

        ],
      ),
    ),);
  }
}