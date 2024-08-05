import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/authentication_page/login_page.dart';
import '../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../support/logger.dart';
import 'forgot_otp.dart';

class newpassword extends StatefulWidget {
  final String email;

  const newpassword({required this.email,super.key});

  @override
  State<newpassword> createState() => _newpasswordState();
}

class _newpasswordState extends State<newpassword> {


  bool hidePassword = true;


  var userid;
  var packagedropdownvalue;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool isButtonDisabled = true;
  bool isLoading = false;


  List package = [];

  String email = '';
  String? password;




  Future newPassword() async {
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'email': widget.email,
        'password': password,

      };

      var response = await AuthService.newpassword(reqData);
      log.i('Password create . $response');

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => login()),
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
                  child: Text("New Password",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700,color: bluetext),)),
            ),
        
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Align(
            //       alignment: Alignment.topLeft,
            //       child: Text("Enter Your New Password",style: TextStyle(fontSize: 12),)),
            // ),
        
            SizedBox(height: 20,),
        
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: hidePassword2,
                decoration: InputDecoration(
                  hintText: 'New Password',
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
        
                  suffixIcon: IconButton(
                    icon: hidePassword2
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        hidePassword2 = !hidePassword2;
                      });
                    },
                  ),
        
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 15,// You can replace 'Icons.email' with the icon you want
                    color: bordercolor,
                  ),
        
                ),
        
                onChanged: (text) {
                  setState(() {
                    password=text;
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),
        
        
            SizedBox(height: 20,),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
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
        
                  suffixIcon: IconButton(
                    icon: hidePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
        
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 15,// You can replace 'Icons.email' with the icon you want
                    color: bordercolor,
                  ),
        
                ),
        
                onChanged: (text) {
                  setState(() {
                    password=text;
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),
        
            SizedBox(height: 20,),
        
        
        
            InkWell(
              onTap: (){
                newPassword();
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
        
            SizedBox(height: 50,),
        
        
        
          ],
        ),
      ),
    );
  }
}
