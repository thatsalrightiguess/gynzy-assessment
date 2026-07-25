import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/quiz/presentation/pages/quiz_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraction Quiz',
      theme: AppTheme.lightTheme,
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
