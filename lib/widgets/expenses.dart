import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        tital: "Pizza",
        amount: 500,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        tital: "Ahmedabad",
        amount: 45,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        tital: "Movie",
        amount: 270,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        tital: "New Laptop",
        amount: 45000,
        date: DateTime.now(),
        category: Category.work
    3),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense,);
      },
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(child: Text("No Expenses Found. Start Adding Some!"));

    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense,);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add))
        ],
        title: const Text("ExpenseTracker"),
        // backgroundColor: Color.fromARGB(25, 25, 25, 25),
      ),
      body: Column(
        children: [
          const Text("Chart...coming soon"),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
