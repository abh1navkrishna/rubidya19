import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/transfer_rubedium_exchange.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/transfer_rubidium_wallet.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/verification_page.dart';
import '../../../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';

class withdrawalpage extends StatefulWidget {
  const withdrawalpage({super.key});

  @override
  State<withdrawalpage> createState() => _withdrawalpageState();
}

class _withdrawalpageState extends State<withdrawalpage> {


  var profiledetails;
  var userid;
  bool _isLoading = true;


  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }



  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
      ],
    );
    _isLoading = false;
  }



  @override
  void initState() {
    _initLoad();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text(
          "Withdrawal Amount",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [

          SizedBox(height: 20,),


          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          TransferRubidiumWallet()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(child: Text("Transfer to Rubidya wallet",style: TextStyle(fontSize: 14,color: white),)),

                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),

                      ],
                    ),
                  )
              ),
            ),
          ),


          SizedBox(height: 20,),


          InkWell(
            onTap: (){
              // Navigator.of(context).push(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             premiumpage()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(child: Text("Transfer to web3 wallet",style: TextStyle(fontSize: 14,color: white),)),

                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),

                      ],
                    ),
                  )
              ),
            ),
          ),

          SizedBox(height: 20,),
          profiledetails?['user']['isVerified'] == true
              ?

          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          TransferToRubediumExchange()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(child: Text("Transfer to Rubideum Exchange",style: TextStyle(fontSize: 14,color: white),)),

                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),

                      ],
                    ),
                  )
              ),
            ),
          ):
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          Verification()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(child: Text("Transfer to Rubedium Exchange",style: TextStyle(fontSize: 14,color: white),)),

                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),
                      ],
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
