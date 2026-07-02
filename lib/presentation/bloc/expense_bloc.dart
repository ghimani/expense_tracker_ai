import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc(this.repository)
      : super(ExpenseInitial()) {

    on<LoadExpenses>((event, emit) {

      emit(ExpenseLoading());

      final expenses =
      repository.getExpenses();

      emit(
        ExpenseLoaded(expenses),
      );
    });

    on<AddExpense>((event, emit) async {

      await repository.addExpense(
        event.expense.toMap(),
      );

      emit(
        ExpenseLoaded(
          repository.getExpenses(),
        ),
      );
    });

    on<DeleteExpense>((event, emit) async {

      await repository.deleteExpense(
        event.index,
      );

      emit(
        ExpenseLoaded(
          repository.getExpenses(),
        ),
      );
    });
    on<UpdateExpense>((event, emit) async {

      await repository.updateExpense(
        event.index,
        event.expense.toMap(),
      );

      emit(
        ExpenseLoaded(
          repository.getExpenses(),
        ),
      );
    });
  }
}