import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'homescreen.dart';
import 'summary.dart';
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
  final weightController = TextEditingController();
  DateTime? selectedDOB;
  List<int> selectedCycleDates = [];
  final medicalController = TextEditingController();

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  String heightUnit = 'cm';
  int selectedCm = 160;
  int selectedFeet = 5;
  int selectedInch = 4;

  void showHeightPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        String tempUnit = heightUnit;
        int tempCm = selectedCm;
        int tempFeet = selectedFeet;
        int tempInch = selectedInch;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: 350,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text("cm"),
                        selected: tempUnit == 'cm',
                        selectedColor: Colors.purple,
                        onSelected: (_) => setModalState(() => tempUnit = 'cm'),
                        labelStyle: TextStyle(
                          color: tempUnit == 'cm' ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text("feet"),
                        selected: tempUnit == 'feet',
                        selectedColor: Colors.purple,
                        onSelected: (_) =>
                            setModalState(() => tempUnit = 'feet'),
                        labelStyle: TextStyle(
                          color:
                              tempUnit == 'feet' ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: tempUnit == 'cm'
                          ? [
                              Flexible(
                                child: CupertinoPicker(
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: tempCm - 100,
                                  ),
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => tempCm = 100 + index);
                                  },
                                  children: List.generate(
                                    101,
                                    (index) => Text('${100 + index} cm'),
                                  ),
                                ),
                              ),
                            ]
                          : [
                              Flexible(
                                child: CupertinoPicker(
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: tempFeet - 4,
                                  ),
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => tempFeet = 4 + index);
                                  },
                                  children: List.generate(
                                    4,
                                    (index) => Text('${4 + index}\''),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: CupertinoPicker(
                                  itemExtent: 40,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: tempInch,
                                  ),
                                  onSelectedItemChanged: (index) {
                                    setModalState(() => tempInch = index);
                                  },
                                  children: List.generate(
                                    12,
                                    (index) => Text('$index"'),
                                  ),
                                ),
                              ),
                            ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        heightUnit = tempUnit;
                        selectedCm = tempCm;
                        selectedFeet = tempFeet;
                        selectedInch = tempInch;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  )
                ],
              ),
            );
          },
        );
      },
    );
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
              const Text("Select Date of Birth",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate,
                  minimumYear: 1970,
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Select your Cycle Dates (Max 10)"),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  children: List.generate(31, (index) {
                    int day = index + 1;
                    bool selected = selectedCycleDates.contains(day);
                    return InkWell(
                      onTap: () {
                        setModalState(() {
                          setState(() {
                            if (selected) {
                              selectedCycleDates.remove(day);
                            } else if (selectedCycleDates.length < 10) {
                              selectedCycleDates.add(day);
                            }
                          });
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selected
                              ? Colors.deepPurple
                              : Colors.grey.shade200,
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Done"),
                ),
              ],
            );
          },
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
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: Colors.purple.shade100,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
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
                    decoration:
                        _inputDecoration("Last Name", Icons.person_outline),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Weight input
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: _inputDecoration("Weight (kg)", Icons.monitor_weight),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: showHeightPicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.height, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      heightUnit == 'cm'
                          ? 'Height: $selectedCm cm'
                          : "Height: $selectedFeet' $selectedInch\"",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: showDatePickerWheel,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedDOB == null
                          ? "Select your Date of Birth"
                          : "${selectedDOB!.day}-${selectedDOB!.month}-${selectedDOB!.year}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: showCycleDateSelector,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: _boxDecoration(),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.purple),
                    const SizedBox(width: 12),
                    Text(
                      selectedCycleDates.isEmpty
                          ? "Select your Cycle Date"
                          : "Cycle Dates: ${selectedCycleDates.join(', ')}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: medicalController,
              maxLines: 3,
              decoration:
                  _inputDecoration("Any Medical Conditions?", Icons.healing),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Complete"),
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
      counterText: "",
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
