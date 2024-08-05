import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/success_page.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/wallet.dart';
import '../../../../navigation/bottom_navigation.dart';
import '../../../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';
import 'package:easy_debounce/easy_debounce.dart';

class premiuminnerpage extends StatefulWidget {
  premiuminnerpage(
      {super.key,
      required this.amount,
      required this.id,
      required this.packageName});

  String? amount;
  String? id;
  String? packageName;

  @override
  State<premiuminnerpage> createState() => _premiuminnerpageState();
}

class _premiuminnerpageState extends State<premiuminnerpage> {
  var userid;
  String? uniqueId;
  String? amount;
  String? currency;
  String? payId;

  var packages;

  var profiledetails;
  bool isLoading = false;
  bool isPaying = false;

  String deductedAmount = '';
  String deductedmsg = '';

  void _handleTap() {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Debounce the deductbalance function with a delay of 2000 milliseconds (2 seconds)
    EasyDebounce.debounce(
      'deductbalance', // unique ID for debounce
      Duration(milliseconds: 2000),
      deductbalance,
    );

    // After 3 seconds, hide the loading indicator
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }



  Future<void> deductbalance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      String packageamount = widget.amount ?? '';
      String packageid = widget.id ?? '';// Initialize 'amount' here
      var reqData = {
        'amount': packageamount,
        'packageId': packageid,
      };
      var response = await ProfileService.addSubscription(reqData);
      log.i('add-subscription.... . $response');
      verifyuser();
      if (response['sts'] == '01') {
        setState(() {
          deductedAmount = response['deductedAmount'].toString();
          deductedmsg = response['msg'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Sorry,you dont have enough wallet amount to purchase the package'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      // Handle specific error cases
      print(error); // Check if any error is being caught
      if (error.toString().contains("Error deducting")) {
        // Corrected typo in error string
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient Balance'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Deducting Rubideum failed. Check your Rubideum balance'),
            // Show a generic error message
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }


  Future verifyuser() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      String packageid = widget.id ?? '';
      var reqData = {
        // 'amount': deductedAmount,
        'amount': deductedAmount,
        'packageId': packageid,
      };
      print('.....................test1$deductedAmount');
      print('............................test2$packageid');
      SnackBar(
        content: Text('verify user create'),
        duration: Duration(seconds: 3),
      );
      var response = await ProfileService.verifyuser(reqData);
      log.i('verify user create . $response');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => successpage()),
      );
      // Check for success in the response and show a success SnackBar
      if (response['sts'] == 1) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('verify user create'),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
      }

      print("object");
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Insufficient Balance")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient Balance'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  

  Future convertinr() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      String packageamount = widget.amount ?? ''; // Initialize 'amount' here

      var reqData = {
        'amount': packageamount,
      };

      var response = await ProfileService.convertinr(reqData);
      log.i('Done deducting.... . $response');

      if (response['sts'] == '01') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Rubideum deducted successfully'),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Bottomnav()),
        // );

        setState(() {
          deductedAmount = response['convertedAmount'].toString();
          deductedmsg = response['msg'].toString();
        });
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('verify user create'),
      //     duration: Duration(seconds: 2),
      //   ),
      // );

      SnackBar(
        content: Text('Insufficient Balance'),
        duration: Duration(seconds: 3),
      );
    } catch (error) {
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

  Future _initLoad() async {
    await Future.wait(
      [
        convertinr(),
      ],
    );
    isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: bluetext,
        title: Text(
          "Plans",
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            Align(
              alignment: Alignment.center,
              child: Text(
                "${widget.packageName ?? '0'}",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900, color: golden),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // Text(
            //   ' ${deductedAmount.isEmpty ? "N/A" : deductedAmount}',
            //   style: TextStyle(color: appBlueColor),
            // ),

            Align(
              alignment: Alignment.center,
              child: Text(
                "\₹${widget.amount ?? '0'}", // Display the amount here
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: white,
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            SvgPicture.asset(
              'assets/svg/whitelogorubidia.svg',
              fit: BoxFit.cover,
              height: 50,
            ),

            // Align(
            //   alignment: Alignment.center,
            //   child: Text(
            //     "\₹${widget.id ?? 'N/A'}", // Display the amount here
            //     style: TextStyle(
            //       fontSize: 10,
            //       fontWeight: FontWeight.w900,
            //       color: white,
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 30,
            ),

            Container(
              height: 207,
              width: 345,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [premiuminner1, premiuminner2],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "RBD",
                    style: TextStyle(color: white),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SvgPicture.asset(
                        'assets/svg/whitelogorubidia.svg',
                        fit: BoxFit.cover,
                        height: 25,
                      ),
                      Text(
                        ' ${deductedAmount.isEmpty ? "0" : deductedAmount}',
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: white,
                      thickness: .1,
                    ),
                  ),

                  // Text("Your wallet balance is insufficient",style: TextStyle(fontSize: 10,color: pink),),

                  SizedBox(
                    height: 10,
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => wallet()));
                    },
                    child: Container(
                      height: 36,
                      width: 100,
                      decoration: BoxDecoration(
                          color: gradnew,
                          border: Border.all(color: white, width: .3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Wallet",
                            style: TextStyle(color: white, fontSize: 12),
                          ),
                          SvgPicture.asset(
                            'assets/svg/trueicon.svg',
                            fit: BoxFit.cover,
                          ),
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 50,
            ),
// old code
            // InkWell(
            //   onTap: (){
            //     deductbalance();
            //   },
            //   child: Container(
            //     height: 36,
            //     width: 150,
            //     decoration: BoxDecoration(
            //         color: gradnew,
            //         border: Border.all(color: white, width: .3),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: Center(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text("Pay from wallet",style: TextStyle(color: white,fontSize: 12),),
            //
            //           ],
            //         )),),
            //
            // ),


            // InkWell(
            //   onTap: () {
            //     if (!isPaying) {
            //       setState(() {
            //         isPaying = true;
            //       });
            //
            //       deductbalance().then((result) {
            //         setState(() {
            //           isPaying = false;
            //         });
            //
            //         Future.delayed(Duration(seconds: 3), () {
            //           // Any additional actions after the payment is completed
            //         });
            //       });
            //     }
            //   },
            //   child: IgnorePointer(
            //     ignoring: isPaying,
            //     // Ignore pointer events if payment is in progress
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            //           child: Container(
            //             height: 35,
            //             width: 400,
            //             decoration: BoxDecoration(
            //               gradient: LinearGradient(
            //                 begin: Alignment.topCenter,
            //                 end: Alignment.bottomCenter,
            //                 colors: [g1button, g2button],
            //               ),
            //               borderRadius: BorderRadius.all(Radius.circular(10)),
            //             ),
            //             child: Center(
            //               child: Text(
            //                 "Pay From wallet",
            //                 style: TextStyle(color: white, fontSize: 12),
            //               ),
            //             ),
            //           ),
            //         ),
            //         if (isPaying)
            //           CircularProgressIndicator(
            //             valueColor: AlwaysStoppedAnimation<Color>(white),
            //           ),
            //       ],
            //     ),
            //   ),
            // ),

            // InkWell(
            //   onTap: (){
            //     deductbalance();
            //   },
            //   child: Container(
            //     height: 36,
            //     width: 150,
            //     decoration: BoxDecoration(
            //         color: gradnew,
            //         border: Border.all(color: white, width: .3),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Pay from wallet",
            //             style: TextStyle(color: white, fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),



            // InkWell(
            //   onTap: () {
            //     // Debounce the deductbalance function with a delay of 500 milliseconds
            //     EasyDebounce.debounce(
            //       'deductbalance', // unique ID for debounce
            //       Duration(milliseconds: 2000),
            //       deductbalance,
            //     );
            //   },
            //   child: Container(
            //     height: 36,
            //     width: 150,
            //     decoration: BoxDecoration(
            //       color: gradnew,
            //       border: Border.all(color: white, width: .3),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             "Pay from wallet",
            //             style: TextStyle(color: white, fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),


        // InkWell(
        //   onTap: () {
        //     EasyDebounce.debounce(
        //       'deductbalance', // unique ID for debounce
        //       Duration(milliseconds: 3000),
        //           () {
        //         setState(() {
        //           isLoading = true;
        //         });
        //         deductbalance();
        //       },
        //     );
        //   },
        //   child: Container(
        //     height: 40,
        //     width: 300,
        //     decoration: BoxDecoration(
        //       color: gradnew1,
        //       border: Border.all(color: white, width: .3),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Center(
        //       child: isLoading
        //           ? CircularProgressIndicator(
        //         color: Colors.white,
        //       )
        //           : Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(
        //             "Pay from wallet",
        //             style: TextStyle(color: white, fontSize: 12),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: isLoading ? null : _handleTap, // Prevent tapping when loading
                child: Container(
                  height: 36,
                  width: 400,
                  decoration: BoxDecoration(
                    color: white, // Change to your desired color
                    border: Border.all(color: yellow, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pay from wallet",
                          style: TextStyle(color:bluetext, fontSize: 12,fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
