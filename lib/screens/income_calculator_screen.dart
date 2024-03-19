import 'package:flutter/material.dart';
import 'deduction_screen.dart';
import 'chat_screen.dart'; // Import chat screen

class IncomeCalculatorScreen extends StatefulWidget {
  const IncomeCalculatorScreen({Key? key}) : super(key: key);

  @override
  _IncomeCalculatorScreenState createState() => _IncomeCalculatorScreenState();
}

class _IncomeCalculatorScreenState extends State<IncomeCalculatorScreen> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Center(
            child: Text(
              'Income Details',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: IncomeForm(isDarkMode: isDarkMode),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DarkModeToggle(
                  isDarkMode: isDarkMode,
                  toggleTheme: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    _showChatBot(context);
                  },
                  icon: Icon(Icons.chat_bubble, color: isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showChatBot(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ChatGPTScreen(),
        );
      },
    );
  }
}

class IncomeForm extends StatefulWidget {
  final bool isDarkMode;

  const IncomeForm({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController housePropertyController = TextEditingController();
  final TextEditingController businessController = TextEditingController();
  final TextEditingController capitalGainsController = TextEditingController();
  final TextEditingController otherIncomeController = TextEditingController();

  double grossTotalIncome = 0.0;
  bool isGrossTotalIncomeCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        buildTextField(label: 'Salary', controller: salaryController, info: 'Enter your yearly salary'),
        SizedBox(height: 10),
        buildTextField(label: 'House Property Income', controller: housePropertyController, info: 'Please provide the income you receive from your property or properties.'),
        SizedBox(height: 10),
        buildTextField(label: 'Business Income', controller: businessController, info: 'Enter your income from business or self-employment'),
        SizedBox(height: 10),
        buildTextField(label: 'Capital Gains', controller: capitalGainsController, info: "Please provide the income you've generated from capital gains."),
        SizedBox(height: 10),
        buildTextField(label: 'Other Income', controller: otherIncomeController, info: 'Please provide any other additional sources of income you may have.'),
        SizedBox(height: 20),
        Center(
          child: SizedBox(
            width: 310, // Adjusted width
            child: ElevatedButton(
              onPressed: () {
                calculateGrossTotalIncome();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
              child: Text('Calculate Gross Total Income', style: TextStyle(color: Colors.black, fontSize: 18)),
            ),
          ),
        ),
        SizedBox(height: 20),
        if (isGrossTotalIncomeCalculated)
          Center(
            child: SizedBox(
              width: 310, // Adjusted width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeductionScreen(
                        grossTotalIncome: grossTotalIncome,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                child: Text('Deductions', style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ),
        SizedBox(height: 20),
        Center(
          child: Text(
            'Gross Total Income: $grossTotalIncome',
            style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
        if (grossTotalIncome < 50000)
          Center(
            child: Text(
              'Note: Standard Deduction ₹50000 is being deducted from the Salary',
              style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget buildTextField({required String label, required TextEditingController controller, required String info}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: TextFormField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
              filled: true,
              fillColor: widget.isDarkMode ? Colors.black : Colors.white,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: _isValidInput(controller.text) ? Colors.white : Colors.red,
                ),
              ),
            ),
            style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid value';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Information'),
                  content: Text(info),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.info, color: widget.isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }

  bool _isValidInput(String? input) {
    if (input == null || input.isEmpty) {
      return true;
    }
    return double.tryParse(input) != null;
  }

  void calculateGrossTotalIncome() {
    double? salary = double.tryParse(salaryController.text);
    double? housePropertyIncome = double.tryParse(housePropertyController.text);
    double? businessIncome = double.tryParse(businessController.text);
    double? capitalGains = double.tryParse(capitalGainsController.text);
    double? otherIncome = double.tryParse(otherIncomeController.text);

    if (salary == null ||
        housePropertyIncome == null ||
        businessIncome == null ||
        capitalGains == null ||
        otherIncome == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid numeric values.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    salary = (salary - 50000).clamp(0, double.infinity);

    grossTotalIncome = salary +
        housePropertyIncome +
        businessIncome +
        capitalGains +
        otherIncome;

    setState(() {
      isGrossTotalIncomeCalculated = true;
    });
  }
}

class DarkModeToggle extends StatelessWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  DarkModeToggle({required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () {
        toggleTheme();
      },
    );
  }
}
