import 'package:flutter/material.dart';
import 'calculate_tax_screen.dart';
import 'chat_screen.dart';

class DeductionScreen extends StatelessWidget {
  final double grossTotalIncome;

  const DeductionScreen({Key? key, required this.grossTotalIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deduction Calculator', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: _DeductionForm(grossTotalIncome: grossTotalIncome),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatPopup(context);
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.chat, color: Colors.black),
      ),
    );
  }

  void _showChatPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ChatGPTScreen(),
          ),

        );
      },
    );
  }
}

class _DeductionForm extends StatefulWidget {
  final double grossTotalIncome;

  const _DeductionForm({Key? key, required this.grossTotalIncome})
      : super(key: key);

  @override
  __DeductionFormState createState() => __DeductionFormState();
}

class __DeductionFormState extends State<_DeductionForm> {
  late String selectedSection;
  late double section80DLimit;
  late double section80DDBLimit;
  late double section80TTBLimit;
  late double section80CCELimit;
  late String userAge;
  double totalDeductionsOldRegime = 0.0;
  double totalDeductionsNewRegime = 0.0;
  String suggestion = '';

  var sections = [
    'Section 80CCE',
    'Section 80D',
    'Section 80DD',
    'Section 80DDB',
    'Section 80E',
    'Section 80EEB',
    'Section 80G',
    'Section 80GGC',
    'Section 80TTA',
    'Section 80TTB',
    'Section 80U',
  ];

  var subdivisions = {
    'Section 80CCE': ['No Subsections'],
    'Section 80D': ['No Subsections'],
    'Section 80DD': ['Deduction for Disability'],
    'Section 80DDB': ['No Subsections'],
    'Section 80E': ['Interest on Education Loan'],
    'Section 80EEB': ['Interest on Loan for Purchase of Electric Vehicle'],
    'Section 80G': ['Donations'],
    'Section 80GGC': ['Contributions to Political Parties'],
    'Section 80TTA': ['Savings Account Interest'],
    'Section 80TTB': ['No Subsections'],
    'Section 80U': ['Deduction for Person with Disability'],
  };

  final TextEditingController deductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSection = sections[0];
    section80DLimit = 25000;
    section80DDBLimit = 40000;
    section80TTBLimit = 50000;
    section80CCELimit = 150000;
    userAge = '';
  }
  bool _isValidAgeInput() {
    if (userAge.isEmpty) return true;
    final RegExp _numeric = RegExp(r'^[0-9]+$');
    return _numeric.hasMatch(userAge);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isValidAgeInput() ? Colors.white : Colors.red,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Your Age',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isValidAgeInput() ? Colors.white : Colors.red, // Change border color based on input validity
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _isValidAgeInput() ? Colors.white : Colors.red, // Change border color based on input validity
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    userAge = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedSection,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              dropdownColor: Colors.black,
              items: sections.map((String section) {
                return DropdownMenuItem(
                  value: section,
                  child: Text(section, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSection = newValue!;
                  updateSectionLimits();
                });
              },
            ),
            SizedBox(height: 20),
            buildDeductionField(
              label: 'Enter Deduction Value',
              controller: deductionController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateDeductions();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF585a5e),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: Text('Calculate Deductions', style: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculateTaxScreen(
                      totalDeductionsOldRegime: totalDeductionsOldRegime,
                      totalDeductionsNewRegime: totalDeductionsNewRegime,
                      userAge: userAge,
                      grossTotalIncome: widget.grossTotalIncome,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF585a5e),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: Text('Calculate Tax', style: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildDeductionField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      controller: controller,
    );
  }

  void updateSectionLimits() {
    switch (selectedSection) {
      case 'Section 80D':
        section80DLimit = (userAge.isEmpty || int.parse(userAge) < 60)
            ? 25000
            : 50000;
        break;
      case 'Section 80DDB':
        section80DDBLimit = (userAge.isEmpty || int.parse(userAge) < 60)
            ? 40000
            : 100000;
        break;
      case 'Section 80TTB':
        section80TTBLimit = 50000;
        break;
      case 'Section 80CCE':
        section80CCELimit = 150000;
        break;
    }
  }

  void calculateDeductions() {
    if (!_isValidAgeInput()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Age', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            content: Text(
              'Please enter a valid age (numeric characters only).',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      );
      return;
    }

    double deductionValue = double.tryParse(deductionController.text) ?? 0.0;

    switch (selectedSection) {
      case 'Section 80D':
        handleSection80D(deductionValue);
        break;
      case 'Section 80DDB':
        handleSection80DDB(deductionValue);
        break;
      case 'Section 80TTB':
        handleSection80TTB(deductionValue);
        break;
      case 'Section 80CCE':
        handleSection80CCE(deductionValue);
        break;
    }

    totalDeductionsOldRegime += deductionValue;

    if (selectedSection == 'Section 80CCD' || selectedSection == 'Section 80TTB') {
      totalDeductionsNewRegime += deductionValue;
    }

    if (totalDeductionsOldRegime < totalDeductionsNewRegime) {
      suggestion = 'Old Regime is Comparatively lower than New Regime';
    } else if (totalDeductionsOldRegime > totalDeductionsNewRegime) {
      suggestion = 'New Regime is Comparatively lower';
    } else {
      suggestion = 'Old Regime and New Regime have equal deductions';
    }

    double totalIncomeAfterDeductions =
        widget.grossTotalIncome - totalDeductionsOldRegime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deduction Results', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          content: Column(
            children: [
              Text('Total Deductions (Old Regime): $totalDeductionsOldRegime', style: TextStyle(color: Colors.white)),
              Text('Total Deductions (New Regime): $totalDeductionsNewRegime', style: TextStyle(color: Colors.white)),
              Text(
                'Total Income After Deductions (Old Regime): $totalIncomeAfterDeductions',
                style: TextStyle(color: Colors.white),
              ),
              Text('Suggestion: $suggestion', style: TextStyle(color: Colors.white)),
              Text('User Age: $userAge', style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void handleSection80D(double deductionValue) {
    if (deductionValue > section80DLimit) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Section 80D Limit Exceeded', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            content: Text(
              'You can only claim up to ₹${section80DLimit.toStringAsFixed(2)} for Section 80D. '
                  'The excess amount will not be considered for deduction.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }

  void handleSection80DDB(double deductionValue) {
    if (deductionValue > section80DDBLimit) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Section 80DDB Limit Exceeded', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            content: Text(
              'You can only claim up to ₹${section80DDBLimit.toStringAsFixed(2)} for Section 80DDB. '
                  'The excess amount will not be considered for deduction.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }

  void handleSection80TTB(double deductionValue) {
    if (userAge.isEmpty || int.parse(userAge) < 60) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Section 80TTB Applicability'),
            content: const Text(
              'Section 80TTB is only applicable for senior citizens (age >= 60). '
                  'Please make sure the age is correctly entered.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      totalDeductionsOldRegime += deductionValue;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Section 80TTB Deduction'),
            content: Text(
              'You have claimed ₹${deductionValue.toStringAsFixed(2)} for Section 80TTB.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void handleSection80CCE(double deductionValue) {
    if (deductionValue > section80CCELimit) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Section 80CCE Limit Exceeded', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
            content: Text(
              'You can only claim up to ₹${section80CCELimit.toStringAsFixed(2)} for Section 80CCE. '
                  'The excess amount will not be considered for deduction.',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    }
  }
}