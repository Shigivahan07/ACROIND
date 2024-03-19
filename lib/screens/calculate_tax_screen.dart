import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalculateTaxScreen extends StatefulWidget {
  final double totalDeductionsOldRegime;
  final double totalDeductionsNewRegime;
  final String userAge;
  final double grossTotalIncome;

  CalculateTaxScreen({
    required this.totalDeductionsOldRegime,
    required this.totalDeductionsNewRegime,
    required this.userAge,
    required this.grossTotalIncome,
  });

  @override
  _CalculateTaxScreenState createState() => _CalculateTaxScreenState();
}

class _CalculateTaxScreenState extends State<CalculateTaxScreen> {
  double _taxOldRegime = 0.0;
  double _taxNewRegime = 0.0;
  String _taxComparisonResult = '';
  String _apiCode = '';

  @override
  void initState() {
    super.initState();
    _calculateTaxes();
    _fetchApiCode();
  }

  void _calculateTaxes() {
    double incomeAfterDeductionOldRegime = widget.grossTotalIncome - widget.totalDeductionsOldRegime;
    double incomeAfterDeductionNewRegime = widget.grossTotalIncome - widget.totalDeductionsNewRegime;

    _taxOldRegime = calculateTaxOldRegime(incomeAfterDeductionOldRegime);
    _taxNewRegime = calculateTaxNewRegime(incomeAfterDeductionNewRegime);

    _taxComparisonResult = compareTaxRegimes(_taxOldRegime, _taxNewRegime);
  }

  Future<void> _fetchApiCode() async {
    try {
      final response = await http.post(
        Uri.parse('http://13.48.136.54:8000/api/api-code/'),
        headers: {
          'Authorization': 'Bearer d38cffce-0b1d-464d-83ac-f0f6693f9bad',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _apiCode = responseData['api_code'];
        });
      } else {
        print('Failed to fetch API code: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch API code: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Calculation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Income After Deduction (Old Regime): ${widget.grossTotalIncome - widget.totalDeductionsOldRegime}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 32),
            Text('Tax to be Paid (Old Regime): $_taxOldRegime', style: TextStyle(color: Colors.white)),
            SizedBox(height: 32),
            Text('Income After Deduction (New Regime): ${widget.grossTotalIncome - widget.totalDeductionsNewRegime}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 16),
            Text('Tax to be Paid (New Regime): $_taxNewRegime', style: TextStyle(color: Colors.white)),
            SizedBox(height: 32),
            Text('Tax Comparison Result: $_taxComparisonResult', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.all(8.0),
        child: Text(
          'API Code: $_apiCode',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  double calculateTaxOldRegime(double income) {
    if (income <= 250000) {
      return 0.0;
    } else if (income <= 500000) {
      return 0.05 * (income - 250000);
    } else if (income <= 1000000) {
      return 12500 + 0.2 * (income - 500000);
    } else {
      return 112500 + 0.3 * (income - 1000000);
    }
  }

  double calculateTaxNewRegime(double income) {
    if (income <= 300000) {
      return 0.0;
    } else if (income <= 600000) {
      return 0.05 * income;
    } else if (income <= 900000) {
      return 0.1 * income;
    } else if (income <= 1200000) {
      return 0.15 * income;
    } else if (income <= 1500000) {
      return 0.2 * income;
    } else {
      return 0.3 * income;
    }
  }

  String compareTaxRegimes(double taxOldRegime, double taxNewRegime) {
    if (taxNewRegime < taxOldRegime) {
      return 'New Regime is Better';
    } else if (taxOldRegime < taxNewRegime) {
      return 'Old Regime is Better';
    } else {
      return 'Old Regime and New Regime have equal tax values';
    }
  }

}
