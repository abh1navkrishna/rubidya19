import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:rubidya/authentication_page/verify_otp.dart';
import '../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import '../support/logger.dart';
import 'login_page.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {

  bool hidePassword = true;


  var userid;
  var packagedropdownvalue;
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool isButtonDisabled = true;
  bool isLoading = false;


  List package = [];

  String? firstname;
  String? lastName;
  String? email;
  String? countryCode;
  String? phone;
  String? password;


  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');


  Future userRegistration() async {
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'firstName': firstname,
        'lastName': lastName,
        'phone': phone,
        'countryCode': _selectedCountry.phoneCode,
        "email": email,
        "password": password,
      };

      print(_selectedCountry.phoneCode);

      var response = await AuthService.registration(reqData);
      log.i('add member create . $response');


      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => otpverification(userId: response['userId'])),
              (route) => false);

      if (response['msg'] == 'User Add Successfully') {

        final String userId = response['userId'];


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
            content: Text('Error: User already exists'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  void updateButtonState() {
    setState(() {
      isButtonDisabled = firstname == null ||
          email == null ||
          phone == null ||
          password == null ||
          packagedropdownvalue == null;
    });
  }

  bool validateForm() {
    if (firstname == null || firstname!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid name'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (email == null ||
        !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (phone == null || phone!.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number must be at least 10 numbers long'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (password == null || password!.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 8 characters long'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 80,),
            Center(
              child: SvgPicture.asset(
                "assets/svg/registrationsc.svg",
              ),
            ),

            SizedBox(height: 50,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Sign Up",style: TextStyle(
                    fontWeight:FontWeight.w600,
                    fontSize: 22,color: bluetext),),
              ),
            ),

            SizedBox(height: 10,),

            // Text(
            //   'UserID: $userid',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'First Name',
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
                    firstname=text;
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Last Name',
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
                    lastName=text;
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
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

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Row(
                children: [
                  Container(

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: bordercolor
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CountryPickerDropdown(
                        initialValue: _selectedCountry == null ? 'IN' : _selectedCountry.isoCode,
                        itemBuilder: (Country country) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CountryPickerUtils.getDefaultFlagImage(country),
                              SizedBox(width: 5),
                              Text(
                                "${country.phoneCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${country.isoCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          );
                        },
                        onValuePicked: (Country country) {
                          setState(() {
                            _selectedCountry = country;
                            print(_selectedCountry);
                          });
                        },
                      ),
                    ),
                  ),

                  // SizedBox(width: 5,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: 169,

                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
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
                            Icons.phone_android,
                            size: 15,// You can replace 'Icons.email' with the icon you want
                            color: bordercolor,
                          ),

                        ),

                        onChanged: (text) {
                          setState(() {
                            phone=text;
                          });
                        },
                        style: TextStyle(color: textblack,fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                obscureText: hidePassword2,
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



            InkWell(
              onTap: () {
                if (validateForm()) {
                  // Set isLoading to true to show the loader
                  setState(() {
                    isLoading = true;
                  });

                  // Perform your asynchronous operation, for example, userRegistration()
                  userRegistration().then((result) {
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 12,
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


            SizedBox(height: 70,)


          ],
        ),
      ),

    );
  }
}




