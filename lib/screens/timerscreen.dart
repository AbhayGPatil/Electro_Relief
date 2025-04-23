import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart'; // Import for Lottie animation

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _minutes = 0;
  int _seconds = 0;
  late Timer _timer;
  bool _isTimerRunning = false;
  bool _isComplete = false;
  String _selectedAnimation = ''; // Variable to store selected animation

  // Start the countdown timer
  void _startTimer(int minutes) {
    if (_isTimerRunning)
      return; // Prevent starting the timer if it's already running

    setState(() {
      _isTimerRunning = true;
      _minutes = minutes;
      _seconds = 0;
      _isComplete = false; // Reset completion status
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else if (_minutes > 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isTimerRunning = false;
          _isComplete =
              true; // Mark the session as complete when the timer ends
        });
      }
    });
  }

  // Stop the timer
  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isTimerRunning = false;
      _isComplete =
          true; // Mark the session as complete when the timer is stopped manually
    });
  }

  // Complete the session when clicked
  void _completeSession() {
    // Show the dialog box with the message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hope you are Pain Reliefed"),
          content: const Text("We hope your session has been helpful!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Navigate to HomeScreen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Select animation based on the timer selection
  void _selectAnimation(String animation) {
    setState(() {
      _selectedAnimation = animation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lets Start'),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select a Timer Duration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 30),

              // Timer selection buttons
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectAnimation(
                              'infinity-loop'); // Select infinity-loop animation
                          _startTimer(15); // Start 15 minutes timer
                        },
                        child: const Text('15 Min'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _selectAnimation(
                              'load.json'); // Select progress-bar animation
                          _startTimer(20); // Start 20 minutes timer
                        },
                        child: const Text('20 Min'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Timer Display in a Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  child: Column(
                    children: [
                      Text(
                        '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Display selected animation (if available)
                      if (_selectedAnimation.isNotEmpty)
                        Lottie.asset(
                          'assets/$_selectedAnimation.json',
                          width: 100, // Adjust size if needed
                          height: 400, // Adjust size if needed
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 20),
                      // Stop Button
                      if (_isTimerRunning)
                        ElevatedButton(
                          onPressed: _stopTimer,
                          child: const Text('Stop Session'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Complete Button
                      if (_isComplete)
                        ElevatedButton(
                          onPressed: _completeSession,
                          child: const Text('Complete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
