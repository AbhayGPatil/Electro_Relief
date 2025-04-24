import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

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
  String _selectedAnimation = '';

  void _startTimer(int minutes) {
    if (_isTimerRunning) return;

    setState(() {
      _isTimerRunning = true;
      _minutes = minutes;
      _seconds = 0;
      _isComplete = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else if (_minutes > 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isTimerRunning = false;
          _isComplete = true;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isTimerRunning = false;
      _isComplete = true;
    });
  }

  void _completeSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hope you are Pain Reliefed"),
          content: const Text("We hope your session has been helpful!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _selectAnimation(String animation) {
    setState(() {
      _selectedAnimation = animation;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FA),
      appBar: AppBar(
        title: const Text('Let’s Start'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Select Session Duration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 24),

              // Timer selection inside card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTimeButton('15 min', () {
                        _selectAnimation('infinity-loop');
                        _startTimer(15);
                      }),
                      _buildTimeButton('20 min', () {
                        _selectAnimation('progress-bar');
                        _startTimer(20);
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Timer + Animation Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_selectedAnimation.isNotEmpty)
                        Lottie.asset(
                          'assets/$_selectedAnimation.json',
                          width: 180,
                          height: 180,
                        ),
                      const SizedBox(height: 24),
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

  Widget _buildTimeButton(String label, VoidCallback onPressed) {
    return Material(
      elevation: 6,
      shape: const CircleBorder(),
      shadowColor: Colors.black45,
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
