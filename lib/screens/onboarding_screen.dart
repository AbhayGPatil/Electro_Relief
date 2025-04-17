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

  String heightUnit = 'cm';
  int selectedCm = 160;
  int selectedFeet = 5;
  int selectedInch = 4;
  // void showHeightPicker() {
  //   print("heightpicker called");
  //   print("%%%%%%%%%");
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true, // ✅ Helps for full height on small screens
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) {
  //       String tempUnit = heightUnit;
  //       int tempCm = selectedCm;
  //       int tempFeet = selectedFeet;
  //       int tempInch = selectedInch;

  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           return SizedBox(
  //             height: 350,
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: 12),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     ChoiceChip(
  //                       label: const Text("cm"),
  //                       selected: tempUnit == 'cm',
  //                       selectedColor: Colors.purple,
  //                       onSelected: (_) => setModalState(() => tempUnit = 'cm'),
  //                       labelStyle: TextStyle(
  //                         color: tempUnit == 'cm' ? Colors.white : Colors.black,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     ChoiceChip(
  //                       label: const Text("feet"),
  //                       selected: tempUnit == 'feet',
  //                       selectedColor: Colors.purple,
  //                       onSelected: (_) =>
  //                           setModalState(() => tempUnit = 'feet'),
  //                       labelStyle: TextStyle(
  //                         color:
  //                             tempUnit == 'feet' ? Colors.white : Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 20),
  //                 SizedBox(
  //                   height: 180,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: tempUnit == 'cm'
  //                         ? [
  //                             CupertinoPicker(
  //                               itemExtent: 40,
  //                               scrollController: FixedExtentScrollController(
  //                                   // initialItem: tempCm - 100),
  //                                   initialItem: tempCm - 100),
  //                               onSelectedItemChanged: (index) {
  //                                 setModalState(() => tempCm = 100 + index);
  //                               },
  //                               children: List.generate(
  //                                 101,
  //                                 (index) => Text('${100 + index} cm'),
  //                               ),
  //                             ),
  //                           ]
  //                         : [
  //                             CupertinoPicker(
  //                               itemExtent: 40,
  //                               scrollController: FixedExtentScrollController(
  //                                   initialItem: tempFeet - 4),
  //                               onSelectedItemChanged: (index) {
  //                                 setModalState(() => tempFeet = 4 + index);
  //                               },
  //                               children: List.generate(
  //                                 4,
  //                                 (index) => Text('${4 + index}\''),
  //                               ),
  //                             ),
  //                             CupertinoPicker(
  //                               itemExtent: 40,
  //                               scrollController: FixedExtentScrollController(
  //                                   initialItem: tempInch),
  //                               onSelectedItemChanged: (index) {
  //                                 setModalState(() => tempInch = index);
  //                               },
  //                               children: List.generate(
  //                                 12,
  //                                 (index) => Text('$index"'),
  //                               ),
  //                             ),
  //                           ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       heightUnit = tempUnit;
  //                       selectedCm = tempCm;
  //                       selectedFeet = tempFeet;
  //                       selectedInch = tempInch;
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text("Done"),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
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
        List<int> tempDates = List.from(selectedCycleDates);
        return AlertDialog(
          title: const Text("Select your Cycle Dates"),
          content: Wrap(
            children: List.generate(
              31,
              (index) {
                int day = index + 0;
                bool selected = tempDates.contains(day);
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        tempDates.remove(day);
                      } else if (tempDates.length < 2) {
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
            //// Height place picker start
            const SizedBox(height: 20),

            InkWell(
              onTap: showHeightPicker, // 👈 Make sure this is wired
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

            /// height picker end
            const SizedBox(height: 20),

            // Date of Birth
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

            // Cycle Dates
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
                          : "Cycle Date: ${selectedCycleDates.join(', ')}",
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
              decoration:
                  _inputDecoration("Any Medical Conditions?", Icons.healing),
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
