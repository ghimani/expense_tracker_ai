import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../../core/services/gemini_service.dart';

class SpendingInsightsScreen extends StatefulWidget {
  const SpendingInsightsScreen({super.key});

  @override
  State<SpendingInsightsScreen> createState() =>
      _SpendingInsightsScreenState();
}

class _SpendingInsightsScreenState
    extends State<SpendingInsightsScreen> {

  String insight = "";
  bool isLoading = false;

  Future<void> generateInsights(
      List expenses) async {
    if (expenses.isEmpty) {
      setState(() {
        insight = "No expenses available";
      });
      return;
    }

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      final result =
      await GeminiService()
          .generateInsights(expenses);

      setState(() {
        insight = result
            .replaceAll("**", "")
            .replaceAll("* ", "• ");
      });

    } catch (e) {

      setState(() {
        insight = e.toString();
      });

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          "AI Spending Insights",
        ),
      ),

      body: BlocBuilder<
          ExpenseBloc,
          ExpenseState>(
        builder: (context, state) {

          if (state is ExpenseLoaded) {

            return Padding(
              padding:
              const EdgeInsets.all(16),

              child: Column(
                children: [

                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => generateInsights(state.expenses),


                      child: Text(
                        isLoading
                            ? "Generating..."
                            : insight.isEmpty
                            ? "Generate Report"
                            : "Refresh Report",
                      ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  if (isLoading)
                    const CircularProgressIndicator(),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        insight,
                        style:
                        const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}