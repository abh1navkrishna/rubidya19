import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../services/wallet_service.dart';
import '../../../../../support/logger.dart';
import '../../../../services/profile_service.dart';

class wallet extends StatefulWidget {
  const wallet({super.key});

  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {

  var userid;
  var walletmarketvalue;
  var walletbalance;
  bool _isLoading = true;
  String balance = '';
  var profiledetails;
  // String? uniqueId;
  // String? payId;
  late Timer _timer;
  var clearvalue;
  String balancerubidium = '';



  Future<void> fetchBalance() async {
    final url = 'https://pwyfklahtrh.rubideum.net/basic/getBalance';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "payId": profiledetails?['user']?['payId'] ?? '',
        "uniqueId":profiledetails?['user']?['uniqueId'] ?? '',
        "currency": "RBD",
      }),
    );
    // print("payId: $payId");
    // print("uniqueId: $uniqueId");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        balance = data['balance'].toString();
      });
    } else {
      print('Failed to load balance');
    }
  }


  Future fetchamountsync(String payId, String uniqueId,String balance) async {

    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      String walletAmount = profiledetails?['user']?['walletAmount'].toString() ?? 'loading...';
      var reqData = {
        'payId':  profiledetails?['user']?['payId'] ?? '',
        'uniqueId': profiledetails?['user']?['uniqueId'] ?? '',
        "amount":  walletAmount,
        'currency': 'RBD'
      };

      print(".idididididi.......$payId");

      var response = await ProfileService.fetchbalance(reqData);
      log.i('verify user create . $response');

      // Check for success in the response and show a success SnackBar
      if (response['success'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('S yncing wallet'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    catch (error) {
      // Handle specific error cases
      if (error.toString().contains("User Already Exist")) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('verify already exists!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }



  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }




  Future _marketvalueapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await WalletService.marketvalue();
    log.i('wallet data Show.. $response');
    setState(() {
      walletmarketvalue = response;

    });
  }

  Future _syncvalue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.syncwallet();
    log.i('wallet data Show.. $response');
    setState(() {
      clearvalue = response;

    });
  }


  Future _initLoad() async {
    await Future.wait(
      [
        // _syncvalue(),
      // fetchamountsync(
      // balance,
      // profiledetails?['user']?['payId'] ?? '',
      // profiledetails?['user']?['uniqueId'] ?? '',
      // ),
        _marketvalueapi(),
        _profiledetailsapi(),
        fetchBalance(),
      ],

    );
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();


      fetchamountsync(
        balance,
        profiledetails?['user']?['payId'] ?? '',
        profiledetails?['user']?['uniqueId'] ?? '',
      );

      fetchBalance();
      // _syncvalue();
      _profiledetailsapi();


      // fetchBalance();
      // _profiledetailsapi();

      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {

        // _profiledetailsapi();

        // fetchamountsync(
        //   balance,
        //   profiledetails?['user']?['payId'] ?? '',
        //   profiledetails?['user']?['uniqueId'] ?? '',
        // );
        fetchBalance();

        // _profiledetailsapi();

      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text("Wallet",style: TextStyle(fontSize: 15,color: white),),
        automaticallyImplyLeading: false,
      ),
      body:  _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
      :Column(
        children: [


          SizedBox(height: 20,),

          // InkWell(
          //   onTap: (){
          //     fetchamountsync(
          //       profiledetails?['user']?['payId'] ?? '',
          //       profiledetails?['user']?['uniqueId'] ?? '',
          //       balance,
          //
          //     );
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Container(
          //       height: 40,
          //       width: 400,
          //       decoration: BoxDecoration(
          //           color: bluetext,
          //           borderRadius: BorderRadius.all(Radius.circular(10))
          //       ),
          //       child: Center(child: Text("Confirm",style: TextStyle(color: white),)),
          //     ),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 180,

              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradnew, gradnew1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Text("Available balance",style:TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.w300),),

                  SizedBox(height: 10,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/verify.svg",
                        height: 30,
                      ),

                      SizedBox(width: 10,),

                      Text(balance,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 18,color: white),)
                    ],
                  ),

                  SizedBox(height: 10,),

                  // Text("Unrealised Wallet",style:TextStyle(color: white,fontSize: 16,fontWeight: FontWeight.w300),),
                  //
                  // SizedBox(height: 10,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SvgPicture.asset(
                      //   "assets/svg/verify.svg",
                      //   height: 30,
                      // ),

                      SizedBox(width: 10,),

                      // Text(
                      //   (profiledetails?['user']?['walletAmount'].toString() ?? 'loading...'),
                      //   style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: white),
                      // ),
                    ],
                  ),


                  SizedBox(height: 10,),

                  Container(
                    height: 36,
                    width: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: white,
                          width: .2
                        ),
                        gradient: LinearGradient(
                          colors: [gradnew, gradnew1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Sent Money",style: TextStyle(fontSize: 10,color: white),),
                        SizedBox(width: 10,),
                        SvgPicture.asset(
                          "assets/svg/arrow.svg",
                          height: 7,
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),

          SizedBox(height: 50,),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              // height: 330,
              width: 400,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradnew, gradnew1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),

              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Align(
                    alignment:Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text("Market Value",style: TextStyle(color: white),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: (walletmarketvalue != null &&
                                walletmarketvalue['data'] != null &&
                                walletmarketvalue['data'].isNotEmpty)
                                ? Text(walletmarketvalue['data']['trading_pairs'], style: TextStyle(color: white))
                                : Text("Data not available", style: TextStyle(color: white)),
                          ),


                          Text(
                            walletmarketvalue['data']?['last_price'] ?? 'N/A',
                            style: TextStyle(color: white, fontWeight: FontWeight.w900, fontSize: 25),
                          ),


                        ],
                      ),


                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: white,thickness: .1,),
                  ),

                  SizedBox(height: 10,),
                  Align(
                    alignment:Alignment.topLeft,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text("Market Value",style: TextStyle(color: white),),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("Volume",style: TextStyle(color: white),),
                          ),

                          Row(
                            children: [
                              Text(
                                (walletmarketvalue['data']?['quote_volume'] ?? 'N/A').toString(),
                                style: TextStyle(color: white, fontWeight: FontWeight.w900, fontSize: 16),
                              ),

                              SizedBox(width: 3,),

                              SvgPicture.asset(
                                "assets/svg/arrowbackdown.svg",
                                height: 9,
                              ),
                            ],


                          ),

                        ],
                      ),



                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("High",style: TextStyle(color: white),),
                          ),

                          Row(
                            children: [
                              Text(
                                (walletmarketvalue['data']?['highest_price_24h'] ?? 'N/A').toString(),
                                style: TextStyle(color: white, fontWeight: FontWeight.w900, fontSize: 18),
                              ),

                              SizedBox(width: 3,),

                              SvgPicture.asset(
                                "assets/svg/arrowbackdown.svg",
                                height: 9,
                              ),

                            ],
                          ),

                        ],
                      ),

                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            child: Text("Low",style: TextStyle(color: white),),
                          ),

                          Row(
                            children: [
                              Text(walletmarketvalue['data']['lowest_price_24h'].toString(),style: TextStyle(color: white,fontWeight: FontWeight.w900,fontSize: 18),),

                              SizedBox(width: 3,),

                              SvgPicture.asset(
                                "assets/svg/arrowbackdown.svg",
                                height: 9,
                              ),
                            ],
                          ),

                        ],
                      ),

                    ],
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Align(
                      alignment:Alignment.topLeft,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text("Price Change 24 hours",style: TextStyle(color: white,fontSize: 10),),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text("RBD",style: TextStyle(color: white,fontWeight: FontWeight.w900),),

                                SizedBox(width: 10,),

                                Container(
                                  height: 18,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: white,
                                          width: .2
                                      ),
                                      gradient: LinearGradient(
                                        colors: [gradnew, gradnew1],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            (walletmarketvalue['data']?['highest_price_24h'] ?? 'N/A').toString(),
                                            style: TextStyle(color: white, fontWeight: FontWeight.w500, fontSize: 10),
                                          ),
                                          SizedBox(width: 5,),

                                          SvgPicture.asset(
                                            "assets/svg/arrowtop.svg",
                                            height: 6,
                                          ),

                                        ],
                                      )),
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20,),

                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}
