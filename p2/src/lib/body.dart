import 'package:flutter/material.dart';
import 'package:src/components/addButton.dart';
import 'package:src/components/currencyInput.dart';
import 'package:src/components/currencyCard.dart';
import 'package:provider/provider.dart';
import 'package:src/components/exchangeCard.dart';
import 'package:src/setCurrencyScreen.dart';
import 'notifier/currency_notifier.dart';

class Body extends StatelessWidget{
  final TextEditingController currencyInputController = TextEditingController();

  Body({super.key});

  @override
  Widget build(BuildContext context){
    CurrencyProvider currencyProvider = Provider.of<CurrencyProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CurrencyCard(
              currencyCode: currencyProvider.getCurrencyAtIndex(0),
              onTap: () {
                Navigator.pushNamed(context, '/setCurrency');
              },
            ),
              CurrencyInput(controller: currencyInputController),
              for (int i = 1; i <  currencyProvider.currenciesList.length; i++)
              ExchangeCard(
                conversion: currencyProvider.getConversionAtIndex(i-1),
                currencyCode: currencyProvider.getCurrencyAtIndex(i),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetCurrencyScreen(indexList: i, addButtonClicked: false,),
                    ),
                  );
                },
                delete: () {
                  Provider.of<CurrencyProvider>(context, listen: false).removeCurrency(i);
                },
              ),

            const AddButton(),
          ],
        ),
      ),
    );
  }
}