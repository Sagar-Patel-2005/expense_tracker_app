import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../database/expense_database.dart';
import 'chart/expenses_chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {

  @override
  void initState() {
    super.initState();

    loadExpenses();
  }

  Future<void> loadExpenses() async {

    final data =
    await ExpenseDatabase.instance
        .getAllExpenses();

    setState(() {
      _registeredExpenses = data;
    });
  }


  List<Expense> _registeredExpenses = [
    // Expense(
    //     tital: "Pizza",
    //     amount: 500,
    //     date: DateTime.now(),
    //     category: Category.food),
    // Expense(
    //     tital: "Ahmedabad",
    //     amount: 45,
    //     date: DateTime.now(),
    //     category: Category.travel),
    // Expense(
    //     tital: "Movie",
    //     amount: 270,
    //     date: DateTime.now(),
    //     category: Category.leisure),
    // Expense(
    //     tital: "New Laptop",
    //     amount: 45000,
    //     date: DateTime.now(),
    //     category: Category.work),
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

  // void _addExpense(Expense expense){
  //   setState(() {
  //     _registeredExpenses.add(expense);
  //   });
  // }

  Future<void> _addExpense(Expense expense) async {
    await ExpenseDatabase.instance.insertExpense(expense, _registeredExpenses.length,);
    setState(() {
      _registeredExpenses.add(expense);
    });

    await loadExpenses();
  }

  Future<void> _removeExpense(Expense expense) async {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    await ExpenseDatabase.instance.deleteExpense(expense.id);
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
          onPressed: () async {
            await ExpenseDatabase.instance.insertExpense(expense, expenseIndex);
            await loadExpenses();
            // setState(() {
            //   _registeredExpenses.insert(expenseIndex, expense);
            // });

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
        // actions: [
        //   IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add))
        // ],
        title: const Text("ExpenseTracker"),
        // backgroundColor: Color.fromARGB(25, 25, 25, 25),
      ),
      body: Column(
        children: [
          ExpensesChart(
            expenses: _registeredExpenses,
          ),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _openAddExpenseOverlay,child: Icon(Icons.add),
      ),
    );
  }
}

