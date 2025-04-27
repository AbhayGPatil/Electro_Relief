// import 'package:flutter/material.dart';
// import 'screens/splash_screen.dart';
// import 'screens/phone_input_screen.dart';
// import 'screens/otp_verification_screen.dart';
// import 'screens/blu.dart'; // 👈 new screen

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ELECTRO RELIEF',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.deepPurple),
//       home: SplashScreen(),
//       routes: {
//         '/phone': (_) => const PhoneInputScreen(),
//         '/bluetooth': (_) => const BluetoothStatusScreen(),
//         //'/otp': (_) => const OtpVerificationScreen(),
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/splash_screen.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/blu.dart'; // 👈 your BluetoothStatusScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestBlePermissions(); // 🔒 Request BLE permissions

  runApp(const MyApp());
}

Future<void> requestBlePermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.locationWhenInUse,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELECTRO RELIEF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: SplashScreen(),
      routes: {
        '/phone': (_) => const PhoneInputScreen(),
        '/bluetooth': (_) => const ClassicBluetoothScreen(),
        // '/otp': (_) => const OtpVerificationScreen(), // optional
      },
    );
  }
}
