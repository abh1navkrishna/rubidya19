import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../navigation/bottom_navigation.dart';
import '../resources/color.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../support/logger.dart';
import 'login_page.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'new_password.dart';

class firstotpenter extends StatefulWidget {
  final String email;
  const firstotpenter({required this.email,super.key});

  @override
  State<firstotpenter> createState() => _firstotpenterState();
}

class _firstotpenterState extends State<firstotpenter> {

  TextEditingController otpController = TextEditingController();

  bool hidePassword = true;

  var userid;
  var packagedropdownvalue;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool isButtonDisabled = true;
  bool isLoading = false;


  List package = [];

  String? userId;
  String otp = '';




  Future forgetotp() async {
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'email': widget.email,
        'OTP': otp,
      };

      var response = await AuthService.forgotpasswordotp(reqData);
      log.i('Otp Verification create . $response');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Bottomnav(

          )),
              (route) => false);

      if (response['msg'] == 'User Add Successfully') {

        final String userId = response['userId'];

        print(userId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully! UserID'),
            duration: Duration(seconds: 3),
          ),
        );

        setState(() {
          userid = userId;
        });
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
            content: Text('Invalid OTP code passed!'),
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

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(
            //     "User ID: ${widget.email}",  // Displaying the userId
            //     style: TextStyle(fontSize: 14, color: textblack),
            //   ),
            // ),

            Center(
                child: SvgPicture.asset(
                  "assets/svg/otppagesc.svg",
                )
            ),

            SizedBox(height: 50,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("OTP Verification",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: bluetext),)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("To reset your password, enter your OTP and verify",style: TextStyle(fontSize: 12),)),
            ),

            SizedBox(height: 20,),


            // OtpTextField(
            //   numberOfFields: 4,
            //   borderColor: Colors.red,
            //   focusedBorderColor: Colors.blue,
            //   margin: EdgeInsets.all(8),
            //   fieldWidth: 50,
            //   borderRadius: BorderRadius.circular(8),
            //   onCodeChanged: (String code) {
            //     otp = code;
            //   },
            // ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OTPTextField(
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: TextStyle(
                    fontSize: 17
                ),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  otp = pin;
                  print(otp);
                },
              ),
            ),


            SizedBox(height: 30,),


            InkWell(
              onTap: (){
                forgetotp();
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


