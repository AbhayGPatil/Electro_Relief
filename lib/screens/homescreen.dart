import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

import 'summary.dart';
import 'qr_scan_screen.dart';
import 'timerscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Bluetooth
  final String targetMac = "3C:61:05:65:3E:9E"; // Your ESP32 MAC
  BluetoothConnection? connection;
  bool isDeviceOn = false;
  bool isConnected = false;
  bool isConnecting = false;

  String pairingStatus = 'Disconnected';
  double intensity = 1;
  int _currentImageIndex = 0;
  final List<String> _images = [
    'assets/i1.jpg',
    'assets/img5.png',
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/four.png'
  ];

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const QrScanScreen(),
    const SummaryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
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

    _attemptBluetoothConnection();
  }

  void _attemptBluetoothConnection() async {
    setState(() => isConnecting = true);

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) async {
      if (r.device.address == targetMac) {
        FlutterBluetoothSerial.instance.cancelDiscovery();

        try {
          connection = await BluetoothConnection.toAddress(targetMac);
          setState(() {
            isConnected = true;
            pairingStatus = 'Device Paired';
            isConnecting = false;
          });
          debugPrint("✅ Connected to $targetMac");
        } catch (e) {
          debugPrint("❌ Connection Failed: $e");
          setState(() {
            isConnected = false;
            isConnecting = false;
          });
        }
      }
    });
  }
  //reconnect code

  void reconnectBluetooth() async {
    // Dispose current connection if any
    if (connection != null) {
      await connection!.close();
      connection = null;
    }

    setState(() {
      isConnected = false;
      isConnecting = true;
      pairingStatus = 'Disconnected';
    });

    _attemptBluetoothConnection(); // Retry connection
  }
//end

  void _sendIntensityMessage(String message) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(message.codeUnits));
      connection!.output.allSent;
      debugPrint("📤 Sent: $message");
    } else {
      debugPrint("⚠️ Not connected to device.");
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              _buildWelcome(),
              const SizedBox(height: 24),
              _buildImageCarousel(),
              const SizedBox(height: 30),
              _buildPairCard(),
              const SizedBox(height: 20),
              _buildBluetoothStatusCard(),
              const SizedBox(height: 30),
              _buildControlCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bluetooth), label: 'Pair'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back 👋",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            SizedBox(height: 4),
            Text("Aenessa",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.person, color: Colors.white),
        )
      ],
    );
  }

  Widget _buildImageCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Image.asset(
          _images[_currentImageIndex],
          key: ValueKey<String>(_images[_currentImageIndex]),
          fit: BoxFit.cover,
          height: 180,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildPairCard() {
    return SlideTransition(
      position: _slideAnimation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bluetooth, color: Colors.deepPurple),
                  SizedBox(width: 10),
                  Text('PAIR YOUR DEVICE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Switch(
                value: isConnected,
                activeColor: Colors.deepPurple,
                onChanged: (_) {},
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildBluetoothStatusCard() {
  //   return Card(
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     elevation: 3,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           isConnecting
  //               ? const CircularProgressIndicator()
  //               : Row(
  //                   children: [
  //                     Icon(
  //                       isConnected
  //                           ? Icons.bluetooth_connected
  //                           : Icons.bluetooth_disabled,
  //                       color: isConnected ? Colors.green : Colors.red,
  //                     ),
  //                     const SizedBox(width: 10),
  //                     Text(isConnected
  //                         ? "Connected to device"
  //                         : "Not Connected"),
  //                   ],
  //                 ),
  //           if (isConnected)
  //             const Padding(
  //               padding: EdgeInsets.only(top: 10),
  //               child: Text("Intensity will be sent on slider change."),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildBluetoothStatusCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            isConnecting
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isConnected
                                ? Icons.bluetooth_connected
                                : Icons.bluetooth_disabled,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Text(isConnected ? "Connected" : "Not Connected"),
                        ],
                      ),
                      if (!isConnected)
                        ElevatedButton.icon(
                          onPressed: reconnectBluetooth,
                          icon: const Icon(Icons.refresh),
                          label: const Text("Reconnect"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                    ],
                  ),
            if (isConnected)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("You can now control intensity from below."),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quick Control',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.flash_on, size: 40, color: Colors.orange),
                Icon(Icons.local_fire_department, size: 40, color: Colors.red),
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
                  final message = intensity == 1
                      ? '0'
                      : intensity == 2
                          ? '1'
                          : '2';
                  _sendIntensityMessage(message);
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isConnected
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TimerScreen()));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Start Session"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
