import 'package:flutter/material.dart';
import 'package:rubidya/authentication_page/registration_page.dart';
import 'package:rubidya/authentication_page/terms_and_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_navigation.dart';
import '../resources/color.dart';
import '../services/auth_service.dart';
import '../support/logger.dart';
import 'first_otp_verification.dart';
import 'forgot_password.dart';
import 'package:flutter_svg/flutter_svg.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  bool hidePassword = true;


  String? email;
  String? password;
  bool isLoading = false;
  bool _isLoader = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();



  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    var reqData = {
      'email': email,
      'password': password,
    };
    try {
      var response = await AuthService.Login(reqData);

      print(reqData);

      if (response['sts'] == '01') {
        log.i('Login Success');
        print('User ID: ${response['_id']}');
        print('Token: ${response['access_token']}');

        print('isOTPVerified: ${response['false']}');

        // _saveAndRedirectToHome(response['access_token'], response['name']);
        _saveAndRedirectToHome(response['access_token'], response['_id']);

        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text('Login Success'),
        //     ));
        //     gotoHome();
        //   } else {
        //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text('Login failed: ${response['msg']}'),
        //     ));
        //     // Uncomment the line below if you want to prevent the page refresh on login failure
        //     // login();
        //   }
        // } catch (error) {
        //   setState(() {
        //     _isLoading = false;
        //     _isLoader = false;
        //   });

        if (response['isOTPVerified'] == false) {
          // Navigate to firstotppassword page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => firstotppassword()),
          );
        } else {
          // Proceed with normal login flow
          _saveAndRedirectToHome(response['access_token'], response['_id']);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Success'),
          ));
          gotoHome();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: ${response['msg']}'),
        ));
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isLoader = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect Username and password   '),
      ));
      log.e('Error during login: $error');
    }
  }


  void _saveAndRedirectToHome(usertoken, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", usertoken);
    await prefs.setString("userid", userId);
  }


  gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Bottomnav()),
            (route) => false);
  }



  bool validateForm() {
    if (email == null || email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
    if (password == null || password!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid password'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SingleChildScrollView(
        child: Column(

          children: [

            SizedBox(height: 80,),
            Center(
              child: Image.asset(
                "assets/image/loginbg2.png",
                height: 238,
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email or mobile number',
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
                    Icons.person,
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



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
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

            InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) =>forgotpassword()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text("Forgot Password?",style: TextStyle(fontSize: 12,color: buttoncolor),)),
              ),
            ),


            InkWell(
              onTap: () {
                if (validateForm()) {
                  // Set isLoading to true to show the loader
                  setState(() {
                    isLoading = true;
                  });

                  // Perform your asynchronous operation, for example, createleave()
                  _login().then((result) {
                    // After the operation is complete, set isLoading to false
                    setState(() {
                      isLoading = false;
                    });

                    // Add a delay to keep the loader visible for a certain duration
                    Future.delayed(Duration(seconds: 2), () {
                      // After the delay, you can perform any additional actions if needed
                    });
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 48,
                      width: 400,
                      decoration: BoxDecoration(
                        color: buttoncolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                    // Circular progress indicator
                    if (isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(white),
                      ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 40,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider()
                    ),
                    SizedBox(width: 10,),

                    Text("OR",style: TextStyle(fontSize: 12),),

                    SizedBox(width: 10,),
                    Expanded(
                        child: Divider()
                    ),
                  ]
              ),
            ),

            SizedBox(height: 50,),


            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const registration()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height:40,
                  width: 400,
                  decoration: BoxDecoration(
                      color: bluetext,
                      borderRadius: BorderRadius.all(Radius.circular(10))),

                  child: Center(child: Text("Create new account",style: TextStyle(fontSize: 12,color: white),)),

                ),
              ),
            ),

            SizedBox(height: 15,),

            TextButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditions()));
            }, child: Text('Terms & Condition' , style: TextStyle(color: Color.fromRGBO(66, 123, 189, 1)),))

          ],
        ),
      ),
    );
  }
}