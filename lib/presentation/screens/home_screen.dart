import 'package:expense_tracker_ai/presentation/screens/receipt_scanner_screen.dart';
import 'package:expense_tracker_ai/presentation/screens/spending_insights_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [

          IconButton(
            icon: const Icon(
              Icons.analytics,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const SpendingInsightsScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(
              Icons.document_scanner,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const ReceiptScannerScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const Center(
                child: Text("No Expenses Found"),
              );
            }
            double totalAmount = 0;

            for (var item in state.expenses) {
              totalAmount += item['amount'];
            }
            return Column(
              children: [

                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),

                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius:
                    BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Total Spending",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "₹${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount:
                    state.expenses.length,

                    itemBuilder:
                        (context, index) {

                      final expense =
                      state.expenses[index];

                      return Card(
                        child:
                        ListTile(
                          leading: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddExpenseScreen(
                                    expense: expense,
                                    index: index,
                                    isEdit: true,
                                  ),
                                ),
                              );
                            },
                          ),

                          title: Text(
                            expense['merchantName'],
                          ),

                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(expense['category']),
                              Text(
                                "₹${expense['amount']}",
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context.read<ExpenseBloc>().add(
                                DeleteExpense(index),
                              );
                            },
                          ),
                        )
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const AddExpenseScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}