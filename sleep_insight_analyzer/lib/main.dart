import 'package:flutter/material.dart';
import 'screens/input_screen.dart';

void main() {
  runApp(const SleepApp());
}

class SleepApp extends StatelessWidget {
  const SleepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sleep Analysis LLM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const InputScreen(),
    );
  }
}
