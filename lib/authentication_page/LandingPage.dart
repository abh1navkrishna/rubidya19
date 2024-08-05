import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_navigation.dart';
import '../services/profile_service.dart';
import '../support/logger.dart';
import 'first_otp_verification.dart';
import 'login_page.dart';
import 'onboarding_screen.dart';

class Landing_Page extends StatefulWidget {
  const Landing_Page({Key? key, required this.title}) : super(key: key);
  //Named Route Id
  static String id = "Landing";
  final String title;
  @override
  _Landing_PageState createState() => _Landing_PageState();
}

class _Landing_PageState extends State<Landing_Page> {
  String? userToken;
  var userid;
  var profiledetails;

  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });

    // Check if isOTPVerified is false and navigate accordingly
    if (profiledetails != null && profiledetails['user'] != null) {
      bool isOTPVerified = profiledetails['user']['isOTPVerified'] ?? false;
      if (!isOTPVerified) {
        gotoOtp();
      } else {
        gotoHome(); // Navigate to home if OTP is verified
      }
    }
  }

  _checkAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('token');

    if (userToken == null || userToken!.isEmpty) {
      gotoLogin();
    } else {
      // If user is authenticated, check OTP verification
      _profiledetailsapi();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Bottomnav()), (route) => false);
  }

  gotoLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => onboardingscreen()), (route) => false);
  }

  gotoOtp() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => firstotppassword()), (route) => false);
  }
}
