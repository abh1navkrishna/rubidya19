import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';


import '../resources/color.dart';
import 'LandingPage.dart';
import 'login_page.dart';
import 'onboarding_screen.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
            () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Landing_Page(title: 'hi',))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Image.asset(
          'assets/logo/logo3.png',
          width: 150, // Set the desired width
          height: 150, // Set the desired height
        ),
      ),
    );
  }
}
