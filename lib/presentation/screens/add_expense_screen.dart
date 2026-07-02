import 'package:flutter/material.dart';
import '../../data/models/expense_model.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseScreen extends StatefulWidget {

  final Map? expense;
  final int? index;
  final bool isEdit;

  const AddExpenseScreen({
    super.key,
    this.expense,
    this.index,
    this.isEdit = false,
  });

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {

  @override
  void initState() {
    super.initState();

    print("EXPENSE DATA = ${widget.expense}");

    if (widget.expense != null) {

      merchantController.text =
          widget.expense!['merchantName'] ?? "";

      amountController.text =
          widget.expense!['amount'].toString();

      String category =
          widget.expense!['category'] ?? "Others";

      category = category.trim();

      if (categories.contains(category)) {
        selectedCategory = category;
      } else {
        selectedCategory = "Others";
      }
    }
  }
  final merchantController =
  TextEditingController();

  final amountController =
  TextEditingController();

  String selectedCategory = "Food";

  final categories = [
    "Food",
    "Shopping",
    "Travel",
    "Utilities",
    "Entertainment",
    "Groceries",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller:
              merchantController,

              decoration:
              const InputDecoration(
                labelText:
                "Merchant Name",
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
              amountController,

              keyboardType:
              TextInputType.number,

              decoration:
              const InputDecoration(
                labelText: "Amount",
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedCategory,

              items: categories
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),

              onChanged: (value) {

                setState(() {
                  selectedCategory =
                  value!;
                });
              },
            ),

            const SizedBox(height: 25),

            ElevatedButton(

              onPressed: () {

                final expense = ExpenseModel(
                  merchantName:
                  merchantController.text,

                  category: selectedCategory,

                  amount: double.parse(
                    amountController.text,
                  ),

                  date: DateTime.now().toString(),
                );

                if (widget.isEdit) {

                  context.read<ExpenseBloc>().add(
                    UpdateExpense(
                      widget.index!,
                      expense,
                    ),
                  );

                } else {

                  context.read<ExpenseBloc>().add(
                    AddExpense(expense),
                  );
                }

                Navigator.pop(context);
              },

              child: Text(
                widget.isEdit
                    ? "Update Expense"
                    : "Save Expense",
              ),
            )
          ],
        ),
      ),
    );
  }
}