import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  File? _imageFile;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  DateTime? selectedDOB;
  List<int> selectedCycleDates = [];
  final medicalController = TextEditingController();

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void showDatePickerWheel() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        DateTime tempDate = selectedDOB ?? DateTime(2000, 1, 1);
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Select Date of Birth", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  minimumYear: 1950,
                  maximumYear: 2025,
                  onDateTimeChanged: (date) {
                    setState(() => selectedDOB = date);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCycleDateSelector() {
    showDialog(
      context: context,
      builder: (_) {
        List<int> tempDates = List.from(selectedCycleDates);
        return AlertDialog(
          title: const Text("Select 3 Cycle Dates"),
          content: Wrap(
            children: List.generate(
              31,
                  (index) {
                int day = index + 1;
                bool selected = tempDates.contains(day);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        tempDates.remove(day);
                      } else if (tempDates.length < 3) {
                        tempDates.add(day);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selected ? Colors.purple : Colors.grey.shade200,
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => selectedCycleDates = tempDates);
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Onboarding"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: Colors.purple.shade100,
                    child: _imageFile == null ? const Icon(Icons.person, size: 50) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.edit, color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Name fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: _inputDecoration("First Name", Icons.person),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: _inputDecoration("Last Name", Icons.person_outline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date of Birth
            InkWell(
              onTap: showDatePickerWheel,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedDOB == null
                          ? "Select Date of Birth"
                          : "${selectedDOB!.day}-${selectedDOB!.month}-${selectedDOB!.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cycle Dates
            InkWell(
              onTap: showCycleDateSelector,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedCycleDates.isEmpty
                          ? "Select 3 Cycle Dates"
                          : "Selected: ${selectedCycleDates.join(', ')}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Medical Condition
            TextField(
              controller: medicalController,
              maxLines: 3,
              decoration: _inputDecoration("Any Medical Conditions?", Icons.healing),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.purple),
      hintText: hint,
      fillColor: Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.purple),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.purple),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.purple),
      borderRadius: BorderRadius.circular(14),
    );
  }
}
