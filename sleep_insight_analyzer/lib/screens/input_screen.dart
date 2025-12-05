import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'results_screen.dart';
import 'package:intl/intl.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final ageController = TextEditingController();
  final sleepDurationController = TextEditingController();
  final wakeUpsController = TextEditingController();   // NEW FIELD
  final caffeineController = TextEditingController();
  final alcoholController = TextEditingController();

  TimeOfDay? bedtime;
  TimeOfDay? wakeup;
  bool genderMale = true;
  bool smoker = false;

  String formatTime(TimeOfDay? t) {
    if (t == null) return 'Select';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  Future<void> onSubmit() async {
    final inputData = {
      "age": int.tryParse(ageController.text) ?? 0,
      "bedtime": bedtime?.format(context) ?? "",
      "wakeup_time": wakeup?.format(context) ?? "",
      "sleep_duration": double.tryParse(sleepDurationController.text) ?? 0.0,

      // NEW FIELD
      "wake_ups": int.tryParse(wakeUpsController.text) ?? 0,

      "caffeine_mg": double.tryParse(caffeineController.text) ?? 0.0,
      "alcohol_units": double.tryParse(alcoholController.text) ?? 0.0,
      "gender_male": genderMale,
      "smoker": smoker,
    };

    // simple loading spinner
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await ApiService.sendSleepData(inputData);

    if (!mounted) return;
    Navigator.of(context).pop(); // close loading

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Input"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Sleep Data",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("Bedtime"),
                      ElevatedButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 22, minute: 0),
                          );
                          setState(() => bedtime = t);
                        },
                        child: Text(formatTime(bedtime)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Wakeup Time"),
                      ElevatedButton(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 7, minute: 0),
                          );
                          setState(() => wakeup = t);
                        },
                        child: Text(formatTime(wakeup)),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: sleepDurationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Sleep Duration (hours)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // NEW INPUT BOX
            TextField(
              controller: wakeUpsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Wake-ups During Night",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: caffeineController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Caffeine Intake (mg)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: alcoholController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Alcohol Units",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text("Gender: Male"),
              value: genderMale,
              onChanged: (v) => setState(() => genderMale = v),
            ),

            SwitchListTile(
              title: const Text("Smoker"),
              value: smoker,
              onChanged: (v) => setState(() => smoker = v),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Analyze Sleep"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}