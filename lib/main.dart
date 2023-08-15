import 'dart:async';
import 'dart:ffi';

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
  int seconds = 20;
  Timer? timer;
  List<String> myList = List.filled(6, "FD") + List.filled(6, "FC");

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => (seconds > 0) ? setState(() => seconds--) : stopTimer());
    Wakelock.enable();
  }

  void stopTimer() {
    timer?.cancel();
    Wakelock.disable();
  }

  void resetTimer() {
    setState(() => seconds = 20);
    stopTimer();
  }

  void plus5() => setState(() => (seconds < 15) ? seconds += 5 : seconds = 20);
  void moins5() => setState(() => (seconds > 5) ? seconds -= 5 : seconds = 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => (timer == null || !timer!.isActive) ? startTimer() : stopTimer(),
        onDoubleTapDown: (d) => (d.globalPosition.dx > MediaQuery.of(context).size.width / 2) ? plus5() : moins5(),
        onLongPress: () => resetTimer(),
        child: Center(
          child: Text(
            '$seconds',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
