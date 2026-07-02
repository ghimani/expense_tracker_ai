import 'package:hive/hive.dart';

class ExpenseRepository {
  final Box expenseBox = Hive.box('expenses');

  Future<void> addExpense(
      Map<String, dynamic> expense) async {
    await expenseBox.add(expense);
  }

  List getExpenses() {
    return expenseBox.values.toList();
  }

  Future<void> deleteExpense(int index) async {
    await expenseBox.deleteAt(index);
  }

  Future<void> updateExpense(
      int index,
      Map<String, dynamic> expense) async {
    await expenseBox.putAt(index, expense);
  }
}