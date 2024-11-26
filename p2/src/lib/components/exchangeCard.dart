import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/currency_notifier.dart';

class ExchangeCard extends StatelessWidget {
  final String currencyCode;
  final double conversion;
  final Function()? onTap;
  final Function()? delete;

  const ExchangeCard({
    Key? key,
    required this.currencyCode,
    required this.conversion,
    this.onTap,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrencyProvider currencyProvider = Provider.of<CurrencyProvider>(context, listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            onTap?.call();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            width: 115,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    currencyCode,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: 225,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  (conversion * currencyProvider.getInputValue()).toStringAsFixed(2).toString(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    delete?.call();
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
