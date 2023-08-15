import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Bip'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rep = 0;
  Timer? timer;
  List<int> reps = List.generate(44, (i) => i % 2 == 0 ? 20 : 10);
  List<String> exercises = List.filled(6, "HC") + List.filled(6, "3FD") + List.filled(2, "3hC") + List.filled(2, "2HC") + List.filled(2, "2hC") + List.filled(2, "2FD") + List.filled(2, "2fD");

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => (reps[rep] > 0) ? setState(() => reps[rep]--) : setState(() => (rep < 45) ? rep++ : resetTimer()));
    Wakelock.enable();
  }

  void stopTimer() {
    timer?.cancel();
    Wakelock.disable();
  }

  void resetTimer() {
    setState(() {
      reps = List.generate(44, (i) => i % 2 == 0 ? 20 : 10);
      rep = 0;
    });
    stopTimer();
  }

  void plus5() => setState(() => (reps[rep] < 15) ? reps[rep] += 5 : reps[rep] = 20);
  void moins5() => setState(() => (reps[rep] > 5) ? reps[rep] -= 5 : reps[rep] = 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (rep % 2 == 0) ? Colors.white : Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => (timer == null || !timer!.isActive) ? startTimer() : stopTimer(),
        onDoubleTapDown: (d) => (d.globalPosition.dx > MediaQuery.of(context).size.width / 2) ? plus5() : moins5(),
        onLongPress: () => resetTimer(),
        child: Center(
          child: (rep % 2 == 0) ? 
            Text(
              '${exercises[rep]}\n${reps[rep]}',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
            ) : 
            Text(
              '${reps[rep]}',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: (rep % 2 == 0) ? Colors.black : Colors.white),
            ),
        ),
      ),
    );
  }
}
