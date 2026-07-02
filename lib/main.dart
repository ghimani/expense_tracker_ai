import 'package:expense_tracker_ai/presentation/bloc/expense_bloc.dart';
import 'package:expense_tracker_ai/presentation/bloc/expense_event.dart';
import 'package:expense_tracker_ai/presentation/screens/home_screen.dart';
import 'package:expense_tracker_ai/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data/repositories/expense_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  await Hive.openBox('expenses');

  runApp(
    BlocProvider(
      create: (_) =>
      ExpenseBloc(
        ExpenseRepository(),
      )..add(
        LoadExpenses(),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}