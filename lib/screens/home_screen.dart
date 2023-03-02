import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 3;
  static const fiveMinutes = 300;
  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  bool showReset = false;
  int totalPomodoros = 0;
  late Timer timer;
  bool isTwentyFiveMinutes = true; // Added variable to track the current timer duration.

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        if (isTwentyFiveMinutes) {
          // If 25-minute timer ended, start 5-minute timer.
          totalSeconds = fiveMinutes;
          isTwentyFiveMinutes = false;
        } else {
          // If 5-minute timer ended, reset the variables.
          totalPomodoros += 1;
          isRunning = false;
          totalSeconds = twentyFiveMinutes;
          isTwentyFiveMinutes = true;
        }
      });
      // Play the alarm sound.
      playAlarmSound();
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void playAlarmSound() {
    // Write code to play the alarm sound here.

  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isRunning = true;
      showReset = true;
    });
  }

  void onPausedPressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetButton() {
    timer.cancel();
    totalSeconds = twentyFiveMinutes;
    isTwentyFiveMinutes = true;
    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onPausedPressed : onStartPressed,
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_circle_outline_outlined),
                  ),
                  IconButton(
                    iconSize: 50,
                    color: Theme.of(context).cardColor,
                    onPressed:  resetButton,
                    icon: const Icon( Icons.restore_rounded),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
