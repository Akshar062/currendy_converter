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

  Future<void> fetchExchangeRate() async {
    try {
      final apiKey = '11831825d93d96968315e4fc6957b00a'; // Replace with your API key
      final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD?access_key=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = data['rates']['INR'];
        setState(() {
          result = double.parse(textEditingController.text) * rate;
        });
      } else {
        setState(() {
          result = 010;
        });
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      // Handle exceptions
      if (kDebugMode) {
        print('Error fetching exchange rate: $e');
      }
    }
  }

  void updateResult() {
    try {
      setState(() {
        result = double.parse(textEditingController.text) * 81;
      });
    } catch (e) {
      // Handle the case when the entered value is not a valid double
      if (kDebugMode) {
        print('Invalid input: ${textEditingController.text}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white70,
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    const hintStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white24,
    );

    const labelStyle = TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.white70,
    );
    const TextStyle textStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    );

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
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            child: TextField(
              controller: textEditingController,
              style: textStyle,
              decoration: const InputDecoration(
                labelText: 'USD',
                labelStyle: labelStyle,
                hintText: 'Enter USD',
                hintStyle: hintStyle,
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Colors.white70,
                ),
                focusedBorder: border,
                enabledBorder: border,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            child: TextField(
              readOnly: true,
              style: textStyle,
              decoration: const InputDecoration(
                labelText: 'Rupees',
                labelStyle: labelStyle,
                hintText: 'Rupees',
                hintStyle: hintStyle,
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: Colors.white70,
                ),
                focusedBorder: border,
                enabledBorder: border,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: TextEditingController(
                text: result.toStringAsFixed(2),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            child: TextField(
              readOnly: true,
              style: textStyle,
              decoration: const InputDecoration(
                labelText: 'Euro',
                labelStyle: labelStyle,
                hintText: 'Euro',
                hintStyle: hintStyle,
                prefixIcon: Icon(
                  Icons.euro,
                  color: Colors.white70,
                ),
                focusedBorder: border,
                enabledBorder: border,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: TextEditingController(
                text: (result / 0.85).toStringAsFixed(2),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 80,
            child: TextField(
              readOnly: true,
              style: textStyle,
              decoration: const InputDecoration(
                labelText: 'Pound',
                labelStyle: labelStyle,
                hintText: 'Pound',
                hintStyle: hintStyle,
                prefixIcon: Icon(
                  Icons.paid,
                  color: Colors.white70,
                ),
                focusedBorder: border,
                enabledBorder: border,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              controller: TextEditingController(
                text: (result / 0.72).toStringAsFixed(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                fetchExchangeRate();
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
