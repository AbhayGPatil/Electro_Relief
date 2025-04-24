import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter_blue/flutter_blue.dart';  // Import Flutter Blue for Bluetooth management
import 'summary.dart'; // Import the SummaryScreen
import 'qr_scan_screen.dart'; // Import QrScanScreen
import 'timerscreen.dart'; // Import the TimerScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isDeviceOn = false;
  String pairingStatus = 'Disconnected';
  double intensity = 1;
  int _currentImageIndex = 0;
  final List<String> _images = [
    'assets/pain.jpg',
    'assets/color_1.jpg',
    'assets/1.png',
    'assets/2.png', 'assets/3.png', 'assets/four.png'
    // Replace with other images later
  ];

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  // To navigate to different screens
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(), // Home screen (you can customize this widget as needed)
    const QrScanScreen(), // Pair screen
    const SummaryScreen(), // Stats screen
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to handle BottomNavigationBar tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  // Check Bluetooth and Device Pairing status
  Future<void> _checkBluetoothAndDevicePairing() async {
    // 1. Check if Bluetooth is on (using Flutter Blue or similar Bluetooth package)
    bool bluetoothIsOn = await _checkBluetoothStatus();

    if (!bluetoothIsOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please turn on Bluetooth")),
      );
      return;
    }

    // 2. Check if the device is paired
    if (isDeviceOn) {
      setState(() {
        pairingStatus = 'Device Paired'; // Assume device is paired by default
      });
      // Proceed to TimerScreen if Bluetooth is on and device is paired
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TimerScreen()),
      );
    } else {
      // If the device is not paired, prompt to pair
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pair your device first")),
      );
    }
  }

  // Simulated method to check Bluetooth status (you can replace it with actual Flutter Blue logic)
  Future<bool> _checkBluetoothStatus() async {
    // In a real app, use FlutterBlue or similar package to check the Bluetooth status
    // Return true if Bluetooth is turned on (simulating with true here)
    return true; // Change this as per your actual logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Welcome Back 👋",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("Aenessa",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.person, color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Animated Carousel
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 600),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: Image.asset(
                              _images[_currentImageIndex],
                              key:
                                  ValueKey<String>(_images[_currentImageIndex]),
                              fit: BoxFit.cover,
                              height: 180,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Device Pairing
                        SlideTransition(
                          position: _slideAnimation,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.bluetooth,
                                              color: Colors.deepPurple),
                                          SizedBox(width: 10),
                                          Text(
                                            'PAIR YOUR DEVICE',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: isDeviceOn,
                                        activeColor: Colors.deepPurple,
                                        onChanged: (value) {
                                          setState(() {
                                            isDeviceOn = value;
                                            pairingStatus = 'Pairing...';
                                          });
                                          if (value) {
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              setState(() {
                                                pairingStatus = 'Device Paired';
                                              });
                                            });
                                          } else {
                                            pairingStatus = 'Disconnected';
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      pairingStatus,
                                      style: TextStyle(
                                          color:
                                              pairingStatus == 'Device Paired'
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  if (pairingStatus == 'Disconnected')
                                    Center(
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Couldn't connect?",
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Quick Controls
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Quick Control',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Icon(Icons.settings,
                                        color: Colors.deepPurple),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(Icons.flash_on,
                                        size: 40, color: Colors.orange),
                                    Icon(Icons.local_fire_department,
                                        size: 40, color: Colors.red),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                const Text('Intensity'),
                                Slider(
                                  value: intensity,
                                  min: 1,
                                  max: 3,
                                  divisions: 2,
                                  label: intensity == 1
                                      ? 'Low'
                                      : intensity == 2
                                          ? 'Medium'
                                          : 'High',
                                  activeColor: Colors.deepPurple,
                                  inactiveColor: Colors.deepPurple.shade100,
                                  onChanged: (value) {
                                    setState(() {
                                      intensity = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _checkBluetoothAndDevicePairing(); // Check Bluetooth and Device Pairing
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text("Start Session"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Pair',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  // Function to handle BottomNavigationBar tab change
}
