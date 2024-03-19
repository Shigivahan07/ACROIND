import 'package:flutter/material.dart';

class TaxCalculator extends StatefulWidget {
  final TextEditingController salaryController;
  final TextEditingController housePropertyController;
  final TextEditingController businessController;
  final TextEditingController capitalGainsController;
  final TextEditingController otherIncomeController;

  const TaxCalculator({
    required this.salaryController,
    required this.housePropertyController,
    required this.businessController,
    required this.capitalGainsController,
    required this.otherIncomeController,
    Key? key,
  }) : super(key: key);

  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {
  double taxPayable = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tax Calculation Results:'),
            Text('Tax Payable: $taxPayable'),
          ],
        ),
      ),
    );
  }

  void calculateTax() {
    double salary = double.parse(widget.salaryController.text);
    double housePropertyIncome =
    double.parse(widget.housePropertyController.text);
    double businessIncome = double.parse(widget.businessController.text);
    double capitalGains = double.parse(widget.capitalGainsController.text);
    double otherIncome = double.parse(widget.otherIncomeController.text);

    double totalIncome = salary +
        housePropertyIncome +
        businessIncome +
        capitalGains +
        otherIncome;
    taxPayable = totalIncome * 0.1;

    setState(() {});
  }
}
