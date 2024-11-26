import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../notifier/currency_notifier.dart';

class CurrencyInput extends StatelessWidget {
  final TextEditingController controller;

  const CurrencyInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: TextField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          Provider.of<CurrencyProvider>(context, listen: false).inputValue = double.tryParse(value) ?? 0;
        },
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: '0.0',
          hintStyle: const TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          isDense: true,
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                Provider.of<CurrencyProvider>(context, listen: false).loadConversions();
              },
              child: const Icon(
                Icons.cached,
                color: Colors.black,
                size: 28,
              ),
            ),
          )
        ),
      ),

    );
  }
}