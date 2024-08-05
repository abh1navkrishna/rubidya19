import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../navigation/bottom_navigation.dart';
import '../../../../resources/color.dart';

class successpage extends StatefulWidget {
  const successpage({super.key});

  @override
  State<successpage> createState() => _successpageState();
}

class _successpageState extends State<successpage> {
  @override

  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Bottomnav())));
  }


  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bluetext,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.asset(
              'assets/logo/success.png',
              height: 360,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),

    );
  }
}
