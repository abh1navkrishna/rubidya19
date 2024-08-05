import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../support/logger.dart';
import 'first_otp_enter.dart';
import 'forgot_otp.dart';

class firstotppassword extends StatefulWidget {
  const firstotppassword({super.key});

  @override
  State<firstotppassword> createState() => _firstotppasswordState();
}

class _firstotppasswordState extends State<firstotppassword> {


  bool hidePassword = true;


  var userid;
  var packagedropdownvalue;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool isButtonDisabled = true;
  bool isLoading = false;


  List package = [];

  String email = '';




  Future forgetPassword() async {
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'email': email,
      };

      var response = await AuthService.forgotpassword(reqData);
      log.i('Otp create . $response');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => firstotpenter(email: email)),
              (route) => false);

      if (response['msg'] == 'User Add Successfully') {
        final String userId = response['userId'];
        print(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully! UserID: $userId'), // Add $userId here
            duration: Duration(seconds: 3),
          ),
        );

        setState(() {
          userid = userId;
        });
      }
      else {
        (response['msg'] == 'Email does not exist');

        SnackBar(
          content: Text('Email does not exist'), // Add $userId here
          duration: Duration(seconds: 3),
        );
      }

    } catch (error) {
      if (error.toString().contains("User Already Exist")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email does not exist'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            SizedBox(height: 150,),
            Center(
                child: Image.asset(
                  "assets/image/forgottpng.png",
                  height: 200,
                )
            ),
        
            SizedBox(height: 50,),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Verify OTP First",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: bluetext),)),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Enter your Email-ID and verify",style: TextStyle(fontSize: 12),)),
            ),
        
            SizedBox(height: 20,),
        
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(color: textblack,fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    size: 15,// You can replace 'Icons.email' with the icon you want
                    color: bordercolor,
                  ),
                ),
        
                onChanged: (text) {
                  setState(() {
                    email=text;
        
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),
        
        
            SizedBox(height: 20,),
        
        
        
            InkWell(
              onTap: (){
                forgetPassword();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 48,
                  width: 400,
                  decoration: BoxDecoration(
                      color: buttoncolor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text("Submit",style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,color: white),),
                  ),
        
                ),
              ),
            ),
        
            SizedBox(height: 40,),
        
        
        
          ],
        ),
      ),
    );
  }
}
