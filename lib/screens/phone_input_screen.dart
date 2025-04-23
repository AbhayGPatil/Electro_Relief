import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context)
              .unfocus(), // Dismiss keyboard on tap outside
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                24, 36, 24, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Icon + Title
                Row(
                  children: const [
                    Icon(Icons.electric_bolt, color: Colors.purple),
                    SizedBox(width: 8),
                    Text(
                      "ELECTRO RELIEF",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Hero Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  // borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/welcome.png',
                    fit: BoxFit.contain, // Keeps full illustration visible
                    height: 300,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Text(
                  "Enter your mobile number to receive a verification code",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 30),

                // Phone Input
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(width: 12),
                        Text("🇮🇳 +91", style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        VerticalDivider(width: 1, thickness: 1),
                      ],
                    ),
                    hintText: "Enter your mobile number",
                    suffixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String phone = phoneController.text.trim();
                      if (phone.isNotEmpty && phone.length >= 10) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OtpVerificationScreen(phoneNumber: phone),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please enter a valid number")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
