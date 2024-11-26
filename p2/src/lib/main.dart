import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src/homeScreen.dart';
import 'package:src/notifier/currency_notifier.dart';
import 'package:src/setCurrencyScreen.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => CurrencyProvider(),
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(),
      routes: {
        '/setCurrency': (context) => const SetCurrencyScreen(indexList: 0, addButtonClicked: false,),
      },
    );
  }
}