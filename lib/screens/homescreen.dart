import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDeviceOn = false;
  String pairingStatus = 'Disconnected';
  double intensity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF833AB4), // Gradient-like purple
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Hi , Aenessa',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // 🔹 Label
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Your Electro Relief',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Carousel
              CarouselSlider(
                items: List.generate(
                  3,
                  (index) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/pain.png', fit: BoxFit.cover),
                  ),
                ),
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Pair Device Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PAIR YOUR DEVICE',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: isDeviceOn,
                    onChanged: (value) {
                      setState(() {
                        isDeviceOn = value;
                        pairingStatus = 'Pairing...';
                      });
                      if (value) {
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            pairingStatus = 'Device Paired';
                          });
                        });
                      } else {
                        pairingStatus = 'Disconnected';
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pairingStatus,
                    style: TextStyle(
                      color: pairingStatus == 'Device Paired'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Quick Control
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Control',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Icon Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.flash_on, size: 40, color: Colors.yellow),
                          Icon(Icons.local_fire_department,
                              size: 40, color: Colors.red),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Intensity',
                        style: TextStyle(color: Colors.white),
                      ),

                      Slider(
                        value: intensity,
                        min: 1,
                        max: 3,
                        divisions: 2,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) {
                          setState(() {
                            intensity = value;
                          });
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Low', style: TextStyle(color: Colors.white)),
                            Text('Medium',
                                style: TextStyle(color: Colors.white)),
                            Text('High', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Start Session Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
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
    );
  }
}
