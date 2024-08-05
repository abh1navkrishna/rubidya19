import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../navigation/bottom_navigation.dart';
import '../../../../../resources/color.dart';
import '../../../../../services/profile_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../support/logger.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {

  TextEditingController payid=TextEditingController();

  var uniqueid;
  bool isLoading = false;
  var userid;
  String? authcode;

  late http.Response response; // Initialize as http.Response
  String uid = '';
  String pid = '';

  // Future<void> fetchBalance() async {
  //   final url = 'https://pwyfklahtrh.rubideum.net/basic/checkPayIdExist';
  //   print("payid---------${payid.text}");
  //   response = await http.post(
  //     Uri.parse(url),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "payId": payid.text.trim(),
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     setState(() {
  //       uid = data['uniqueId'].toString();
  //       pid = data['payId'].toString();
  //     });
  //     addData();
  //
  //
  //   } else if (response.statusCode == 400) {
  //     // Handle 400 Bad Request error
  //     final Map<String, dynamic> errorData = jsonDecode(response.body);
  //     String errorMessage = errorData['message']; // Assuming the error message is in the 'message' field
  //     // Show error message to the user, you can use a dialog, a snackbar, or any other UI element
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Please enter valid Pay Id'),
  //         content: Text(errorMessage),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   else {
  //     print('Failed to load balance: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   }
  // }

  Future verifyaccount() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'payId': payid.text.trim(),
        "authCode": authcode,
      };

      var response = await ProfileService.verifyaccountrubidia(reqData);
      log.i('verify account.... . $response');

      if (response['success'] == 1) {
        setState(() {
          uid = response['uniqueId'].toString();
          pid = response['payId'].toString();
        });
        Future.delayed(Duration(seconds:0), () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Bottomnav()),
                  (route) => false);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Verified Successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        addData();

      }

      else if (response['success']== 0) {


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Enter Valid Pay ID'),
            duration: Duration(seconds: 3),
          ),
        );

      } else {
// Handle other status codes if needed
        print('Unhandled status code: ${response.statusCode}');
      }
    }
    catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Erorr deducting")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erorr deducting'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }



  Future addData() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var reqData = {
        'payId': pid,
        'uniqueId': uid,
      };

      var response = await ProfileService.checkpayid(reqData);
      log.i('add member create . $response');

      // Check for success in the response and show a success SnackBar
      if (response['msg'] == 'PayId added successfully') {


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pay Id Added Successfully'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      else if (response['message']=='Please send the payId and uniqueId') {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'];
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Please send the payId and uniqueId'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
// Handle other status codes if needed
        print('Unhandled status code: ${response.statusCode}');
      }


    }catch (error) {
      // Handle specific error cases
      if (error.toString().contains("User Already Exist")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  void updateButtonState() {
    setState(() {
      payid == null;
    });
  }

  bool validateForm() {
    if (payid == null || payid!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid Pay id'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }



  Future<void> _initLoad() async {
    try {
      // await verifyaccount();
    } catch (error) {
      print('Error: $error');

    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification", style: TextStyle(fontSize: 14)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Please provide your Pay ID from your Rubideum exchange"),
            ),

            // Text('Deducted Amount: ${pid.isEmpty ? "N/A" : pid}'),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: payid,
                decoration: InputDecoration(
                  hintText: 'Pay ID',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    size: 15,
                    color: bordercolor,
                  ),
                ),

                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            SizedBox(height: 5,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Google authenticator code from exchange account',
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
                    authcode=text;
                  });
                },
                style: TextStyle(color: textblack,fontSize: 14),
              ),
            ),

            SizedBox(height: 40,),

            // Text(
            //   'Unique ID: $uid',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            //
            // Text(
            //   'P ID: $pid',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),

            InkWell(
              onTap: () async {
                // fetchBalance();
                verifyaccount();

                if (validateForm()) {
                  setState(() {
                    isLoading = true;
                  });

                  _initLoad().then((result) {
                    setState(() {
                      isLoading = false;
                    });

                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  width: 400,
                  decoration: BoxDecoration(
                    color: bluetext,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(child: Text("Submit", style: TextStyle(fontSize: 12, color: white))),
                ),
              ),
            ),

            SizedBox(height: 20,),


          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have PayID? ",style: TextStyle(color: bluetext),),


              InkWell(
                onTap: () {
                  _launchURL("https://rubideum.net/signup");
                },
                child: Text(
                  "Sign Up ",
                  style: TextStyle(
                    color: bluetext,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: bluetext,// Add underline
                  ),
                ),
              )

            ],
          )

          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}



