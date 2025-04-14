import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';

void main() {
  runApp(const MyApp());
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
        //'/otp': (_) => const OtpVerificationScreen(),
      },
    );
  }
}
