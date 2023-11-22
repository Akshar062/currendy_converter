import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});
  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  final TextEditingController resultEditingController =
  TextEditingController();

  // Map to store conversion rates for each currency
  final Map<String, double> conversionRates = {
    'USD': 1.0, // Default rate for USD
    'Rupees': 0.0, // Set to 0 initially
    'Euro': 0.0,
    'Pound': 0.0,
    // Add more currencies and their rates as needed
  };

  Future<void> fetchExchangeRate(String baseCurrency, String targetCurrency) async {
    try {
      const apiKey = '11831825d93d96968315e4fc6957b00a'; // Replace with your API key
      final url = Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/$baseCurrency?access_key=$apiKey');

      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Update conversion rates from the API
        conversionRates[targetCurrency] = data['rates'][targetCurrency];

        // Perform the conversion using the selected currency rate
        _updateResult(double.parse(textEditingController.text) *
            conversionRates[targetCurrency]!);
      } else {
        _handleError('Failed to fetch exchange rate');
      }
    } catch (e) {
      _handleError('Error fetching exchange rate: $e');
    }
  }

  void _updateResult(double value) {
    setState(() {
      result = value;
      resultEditingController.text = result.toStringAsFixed(2);
    });

    // Print statements for debugging
    print('Updated Result: $result');
    print('Controller Value: ${resultEditingController.text}');
  }


  void _handleError(String message) {
    setState(() {
      result = 0; // Set to a default value or display an error message.
      resultEditingController.text = result.toStringAsFixed(2);
    });

    if (kDebugMode) {
      print(message);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 10,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCurrencyField(
            label: 'USD',
            hintText: 'Enter USD',
            prefixIcon: Icons.attach_money,
            controller: textEditingController,
          ),
          _buildCurrencyField(
            label: 'Rupees',
            hintText: 'Rupees',
            prefixIcon: Icons.currency_rupee,
            controller: resultEditingController,
            readOnly: true,
          ),
          _buildCurrencyField(
            label: 'Euro',
            hintText: 'Euro',
            prefixIcon: Icons.euro,
            controller: resultEditingController,
            readOnly: true,
          ),
          _buildCurrencyField(
            label: 'Pound',
            hintText: 'Pound',
            prefixIcon: Icons.paid,
            controller: resultEditingController,
            readOnly: true,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                fetchExchangeRate('USD', 'Rupees');
                fetchExchangeRate('USD', 'Euro');
                fetchExchangeRate('USD', 'Pound');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black54,
                elevation: 10,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildCurrencyField({
  required String label,
  required String hintText,
  required IconData prefixIcon,
  required TextEditingController controller,
  bool readOnly = false,
}) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    height: 80,
    child: TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white24,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white70,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white70,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white70,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      readOnly: readOnly,
    ),
  );
}