import 'package:flutter/material.dart';
import 'package:expense_tracker_app/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  @override
  // var _enteredTital = "";
  //
  // void _saveTitalInput(String inputValue) {
  //   _enteredTital = inputValue;
  // }

  final _titalController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        //this await tell i wait for value and when i get value i store in the pickedDate variable
        context: context,
        firstDate: firstDate,
        lastDate: now,
        initialDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController
        .text); // tryParse("hello") => null , tryParsse("3.14") => 3.14
    final amountIsInvalid =
        enteredAmount == null || enteredAmount <= 0; /////////21-3min

    if (_titalController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please Make Sure A Valid Tital, Amount, Date And Category Was Entered."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Okay")),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          tital: _titalController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  void dispose() {
    _titalController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(children: [
        TextField(
          controller: _titalController,
          // onChanged: _saveTitalInput,

          maxLength: 50,
          decoration: const InputDecoration(
            label: Text("Tital"),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixText: "₹ ", label: Text("Amount")),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_selectedDate == null
                      ? "No Date Selected"
                      : formetter.format(_selectedDate!)),
                  IconButton(
                    onPressed: _presentDatePicker,
                    icon: Icon(Icons.calendar_month),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            DropdownButton(
                value: _selectedCategory,
                // it is store in the onchange function as (value){..}
                items: Category.values
                    .map(
                      // values(property) is give all the value of enum as a list becuse this item take a list // name is the property to get the item
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
            const Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
              onPressed: _submitExpenseData,
              //() {
              //   // print(_enteredTital);
              //   // String se = _titalController.text.toString();   // _titalController.text;
              // //  print(_titalController.text);
              //   // String amou = _amountController.text.toString();
              // //  print(_amountController.text);
              //
              //
              // },
              child: const Text("Save Expense"),
            )
          ],
        )
      ]),
    );
  }
}
