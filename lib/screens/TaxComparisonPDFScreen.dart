import 'package:flutter/material.dart';

class TaxComparisonPDFScreen extends StatelessWidget {
  final double totalDeductionsOldRegime;
  final double totalDeductionsNewRegime;
  final String userAge;
  final double grossTotalIncome;
  final double taxOldRegime;
  final double taxNewRegime;
  final String taxComparisonResult;

  TaxComparisonPDFScreen({
    required this.totalDeductionsOldRegime,
    required this.totalDeductionsNewRegime,
    required this.userAge,
    required this.grossTotalIncome,
    required this.taxOldRegime,
    required this.taxNewRegime,
    required this.taxComparisonResult,
  });

  @override
  Widget build(BuildContext context) {
    // Implement your PDF viewer here
    return Scaffold(
      appBar: AppBar(
        title: Text('Tax Comparison PDF'),
      ),
      body: Center(
        child: Text('PDF Viewer Goes Here'),
      ),
    );
  }
}
