import 'package:flutter/material.dart';
import 'phone_input_screen.dart';
import 'onboarding_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

 // const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> otpControllers =
  List.generate(5, (_) => TextEditingController());
  int _resendTimer = 30;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;




  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _fadeController.forward();
    _startResendCountdown();
  }


  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendCountdown();
      }
    });
  }

  bool isOtpCorrect() {
    return otpControllers.map((c) => c.text).join() == "12345";
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          children: [
         Image.asset('assets/bg_3.jpg', fit: BoxFit.cover),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(1), Colors.purple.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),

          // 🔹 Foreground fade-in content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Top section
                    Column(
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.medical_services, color: Colors.purple),
                            SizedBox(width: 6),
                            Text(
                              "ELECTRO RELIEF",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.purple
                                ,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // 🔹 Animated shared image
                        Hero(
                          tag: "pain-image",
                          child: Image.asset('assets/pain.jpg', height: 200),
                        ),

                        const SizedBox(height: 30),
                        const Text.rich(
                          TextSpan(
                            text: "Thank You for choosing ",
                            style: TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                text: "ELECTRO RELIEF",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("OTP sent to +91xxxxxxxxxx"),
                        const SizedBox(height: 30),

                        // 🔹 OTP boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            5,
                                (index) => SizedBox(
                              width: 48,
                              child: TextField(
                                controller: otpControllers[index],
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  counterText: "",
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.purple, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.deepPurple, width: 3),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      index < otpControllers.length - 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔁 Resend timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn't receive SMS? "),
                            TextButton(
                              onPressed: _resendTimer == 0
                                  ? () {
                                setState(() => _resendTimer = 30);
                                _startResendCountdown();
                              }
                                  : null,
                              child: Text(
                                "Resend OTP in $_resendTimer",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                    // 🔹 Bottom VERIFY button
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.deepPurpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          final success = isOtpCorrect();

                          if (success) {
                            if (widget.phoneNumber == '7026000565') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP Verified ✅'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingScreen(),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Wrong OTP ❌'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },

                        // style: OutlinedButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //   backgroundColor: Colors.transparent,
                        //   shadowColor: Colors.transparent,
                        //   padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        //   side: BorderSide.none,
                        // ),
                        child: const Text("VERIFY", style: TextStyle(color: Colors.white)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
