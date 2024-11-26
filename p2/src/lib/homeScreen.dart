import 'package:flutter/material.dart';
import 'package:src/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F7),
      appBar: AppBar(
        title: const Text('CURRENCY CONVERTER',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Body()
    );
  }
}