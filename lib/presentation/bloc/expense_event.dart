
import 'package:expense_tracker_ai/data/models/expense_model.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;

  AddExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final int index;

  DeleteExpense(this.index);
}

class UpdateExpense extends ExpenseEvent {
  final int index;
  final ExpenseModel expense;

  UpdateExpense(
      this.index,
      this.expense,
      );
}