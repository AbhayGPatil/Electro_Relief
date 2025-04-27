import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ClassicBluetoothScreen extends StatefulWidget {
  const ClassicBluetoothScreen({super.key});

  @override
  State<ClassicBluetoothScreen> createState() => _ClassicBluetoothScreenState();
}

class _ClassicBluetoothScreenState extends State<ClassicBluetoothScreen> {
  final String targetMac = "3C:61:05:65:3E:9E"; // Your ESP32 MAC
  BluetoothDevice? targetDevice;
  BluetoothConnection? connection;

  bool isConnecting = false;
  bool isConnected = false;

  String receivedData = ""; // ⬅️ Store incoming messages here

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() async {
    setState(() => isConnecting = true);

    FlutterBluetoothSerial.instance.startDiscovery().listen((r) async {
      print("Found: ${r.device.address} - ${r.device.name}");
      if (r.device.address == targetMac) {
        targetDevice = r.device;
        FlutterBluetoothSerial.instance.cancelDiscovery();

        try {
          connection = await BluetoothConnection.toAddress(targetMac);
          setState(() {
            isConnected = true;
            isConnecting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ Connected to $targetMac")),
          );

          connection!.input!.listen((data) {
            String message = String.fromCharCodes(data).trim();
            setState(() {
              receivedData += "$message\n"; // ⬅️ Append to data stream
            });
          }).onDone(() {
            setState(() {
              isConnected = false;
            });
            print('🔌 Disconnected by remote');
          });
        } catch (e) {
          print("❌ Connection failed: $e");
          setState(() => isConnecting = false);
        }
      }
    });
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FA),
      appBar: AppBar(
        title: const Text("Bluetooth Classic Connect"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isConnecting) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text("Connecting to device..."),
            ] else if (!isConnected) ...[
              const Icon(Icons.bluetooth_disabled,
                  color: Colors.red, size: 100),
              const SizedBox(height: 10),
              const Text("❌ Device not connected"),
            ] else ...[
              const Icon(Icons.bluetooth_connected,
                  color: Colors.green, size: 100),
              const SizedBox(height: 10),
              const Text("✅ Device Connected", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              // Display incoming messages
              const Text("Received Data:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.purple.shade100),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Text(
                      receivedData.isEmpty
                          ? "Waiting for data..."
                          : receivedData,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
