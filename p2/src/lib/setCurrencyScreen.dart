import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src/server_stub.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'notifier/currency_notifier.dart';
import 'components/currencyCard.dart';

class SetCurrencyScreen extends StatelessWidget {
  final int indexList;
  final bool addButtonClicked;

  const SetCurrencyScreen({
    Key? key,
    required this.indexList,
    required this.addButtonClicked,
  }) : super(key: key);


  
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<String>>(
      future: getAvailableCurrencies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          String errorMessage = snapshot.error.toString().replaceAll("Exception: ", "");
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return AlertDialog(
            title: const Text('No data available'),
            content: const Text('Check your internet connection'), // Mostrar el mensaje de error
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        } else {
          List<String> availableCurrencies = snapshot.data!;
          final currencyProvider = Provider.of<CurrencyProvider>(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF2F3F7),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.deepPurpleAccent,
              title: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select currency',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableCurrencies.length,
                      itemBuilder: (context, index) {
                        String currencyCode = availableCurrencies[index];
                        return Column(
                          children: [
                            CurrencyCard(
                              currencyCode: currencyCode,
                              onTap: () {
                                if (!addButtonClicked) {
                                  currencyProvider.updateCurrency(indexList, currencyCode);
                                } else {
                                  if (!currencyProvider.currenciesList.contains(currencyCode)) {
                                    currencyProvider.addCurrency(currencyCode);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "That currency is already on the list.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.deepPurpleAccent,
                                        textColor: Colors.white,
                                        fontSize: 15
                                    );
                                  }
                                }
                                Navigator.pop(context);
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
