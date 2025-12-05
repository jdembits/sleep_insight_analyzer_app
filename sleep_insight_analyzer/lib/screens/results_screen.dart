import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sleep Analysis Results"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Results",
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  const JsonEncoder.withIndent('  ')
                      .convert(result),
                  style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}