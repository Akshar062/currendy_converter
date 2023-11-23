import 'package:flutter/material.dart';

import '../functions/getRate.dart';

class ConverterAll extends StatefulWidget {
  final rates;
  final Map currencies;
  const ConverterAll(
      {super.key, @required this.rates, required this.currencies});
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<ConverterAll> {
  String dropdownValue1 = 'USD';
  String dropdownValue2 = 'INR';
  String answer = 'Converted Currency will be shown here';
  TextEditingController amountControllerFirst = TextEditingController();
  TextEditingController amountControllerSecond = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Expanded(
                child: DropdownButton<String>(
                  value: dropdownValue1,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Colors.grey.shade400,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue1 = newValue!;
                    });
                  },
                  items: widget.currencies.keys
                      .toSet()
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ]),
            TextField(
              key: const ValueKey('amount1'),
              controller: amountControllerFirst,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    amountControllerSecond = TextEditingController(text: null);
                  });
                } else {
                  setState(() {
                    amountControllerSecond = TextEditingController(
                        text: convertany(
                            widget.rates, amountControllerFirst.text,
                            dropdownValue1, dropdownValue2));
                  });
                }
              },
              decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: DropdownButton<String>(
                  value: dropdownValue2,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Colors.grey.shade400,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue2 = newValue!;
                    });
                  },
                  items: widget.currencies.keys
                      .toSet()
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ]),
            TextField(
              key: const ValueKey('amount2'),
              controller: amountControllerSecond,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    amountControllerFirst = TextEditingController(text: null);
                  });
                } else {
                  setState(() {
                    amountControllerFirst = TextEditingController(
                        text: convertany(widget.rates, amountControllerSecond.text,
                            dropdownValue2, dropdownValue1));
                  });
                }
              },
              decoration: const InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
