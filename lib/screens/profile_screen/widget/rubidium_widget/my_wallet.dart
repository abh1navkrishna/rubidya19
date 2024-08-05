import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/rubidya_exchange.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/rubidya_premium.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/transaction_History.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/verification_page.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/wallet.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/withdrawal_page.dart';
import '../../../../navigation/bottom_navigation.dart';
import '../../../../resources/color.dart'; // Assuming this is your custom color file
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  bool isExpanded = false;

  bool isExpanded1 = false;
  var profilepagestatus;
  var userid;
  bool _isLoading = true;
  var profiledata;
  var profiledetails;
  var teamperformacestatus;


  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }


  Future _profilestatussapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profilestatus();
    log.i('profile statsus show.. $response');
    setState(() {
      profilepagestatus = response;
    });
  }

  Future _teamperformancesapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.TeamPerformance();
    log.i('profile statsus show.. $response');
    setState(() {
      teamperformacestatus = response;
    });
  }


  Future _initLoad() async {
    await Future.wait(
      [
        _teamperformancesapi(),
        _profilestatussapi(),
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
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text(
          "My Wallet",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: CupertinoNavigationBarBackButton(
          color: white,
          previousPageTitle: "", // Optional: Specify the previous page title
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bottomnav(initialPageIndex: 4)));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            :Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profiledetails?['user']['isVerified'] == true
                ?
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            wallet()));
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 36,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Get wallet", style: TextStyle(fontSize: 10, color: Colors.white)),
                      SizedBox(width: 10),
                      SvgPicture.asset(
                        "assets/svg/addmoney.svg",
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ):InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            Verification()));
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 36,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Get wallet", style: TextStyle(fontSize: 10, color: Colors.white)),
                      SizedBox(width: 10),
                      SvgPicture.asset(
                        "assets/svg/addmoney.svg",
                        height: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                height: isExpanded ? 250 : 145,
                width: 345,
                duration: Duration(milliseconds: 0),
                curve: Curves.easeInOut,
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Available balance", style: TextStyle(fontSize: 12, color: Colors.white))),
                      SizedBox(height: 8),

                      Row(
                        children: [
                          Image.asset(
                            "assets/logo/logowt.png",
                            height: 30,
                          ),
                          SizedBox(width: 5,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              profiledetails?['user']?['walletAmount']?.toString() ?? 'Loading...',
                              style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),

                          Expanded(child: SizedBox()),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isExpanded = !isExpanded; // Toggle the expanded state
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SvgPicture.asset(
                                "assets/svg/walleticon.svg",
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),



                      if (isExpanded)

                        profiledetails?['user']['isVerified'] == true
                            ?
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => RubidyaExchange()));
                                },
                                child: Container(
                                  height: 36,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 0.2),
                                    gradient: LinearGradient(
                                      colors: [gradnew, gradnew1],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Rubidya exchange", style: TextStyle(fontSize: 10, color: Colors.white)),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                        "assets/svg/arrowtop.svg",
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(width: 10,),

                              Container(
                                height: 36,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 0.2),
                                  gradient: LinearGradient(
                                    colors: [gradnew, gradnew1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Wallet connect", style: TextStyle(fontSize: 10, color: Colors.white)),
                                    SizedBox(width: 10),
                                    SvgPicture.asset(
                                      "assets/svg/arrowtop.svg",
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                            padding: const EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 36,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 0.2),
                                    gradient: LinearGradient(
                                      colors: [gradnew, gradnew1],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Rubidya exchange", style: TextStyle(fontSize: 10, color: Colors.white)),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                        "assets/svg/arrowtop.svg",
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Container(
                                  height: 36,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 0.2),
                                    gradient: LinearGradient(
                                      colors: [gradnew, gradnew1],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Wallet connect", style: TextStyle(fontSize: 10, color: Colors.white)),
                                      SizedBox(width: 10),
                                      SvgPicture.asset(
                                        "assets/svg/arrowtop.svg",
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )


                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                height: isExpanded1 ? 250 : 145,
                width: 345,
                duration: Duration(milliseconds: 0),
                curve: Curves.easeInOut,
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("ARS Available balance", style: TextStyle(fontSize: 12, color: Colors.white))),
                      SizedBox(height: 8),


                      Row(

                        children: [

                          Image.asset(
                            "assets/logo/logowt.png",
                            height: 30,
                          ),
                          SizedBox(width: 5,),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "00.0",
                              style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),

                          Expanded(child: SizedBox()),

                          GestureDetector(
                            onTap: (){
                              setState(() {
                                isExpanded1 = !isExpanded1; // Toggle the expanded state
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SvgPicture.asset(
                                "assets/svg/walleticon.svg",
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),



                      if (isExpanded1)

                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 36,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 0.2),
                                  gradient: LinearGradient(
                                    colors: [gradnew, gradnew1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("ARS exchange", style: TextStyle(fontSize: 10, color: Colors.white)),
                                    SizedBox(width: 10),
                                    SvgPicture.asset(
                                      "assets/svg/arrowtop.svg",
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 10,),

                              Container(
                                height: 36,
                                width: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 0.2),
                                  gradient: LinearGradient(
                                    colors: [gradnew, gradnew1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("My wallet", style: TextStyle(fontSize: 10, color: Colors.white)),
                                    SizedBox(width: 10),
                                    SvgPicture.asset(
                                      "assets/svg/arrowtop.svg",
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),





                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            premiumpage()));
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
                    child: Center(child: Text("Subscription Plan",style: TextStyle(fontSize: 14,color: white),))
                ),
              ),
            ),

            SizedBox(height: 20,),


            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: profilepagestatus != null &&
                      profilepagestatus.containsKey('memberProfits')
                      ? profilepagestatus['memberProfits'].length
                      : 0,
                  // Check if profilepagestatus is not null and contains 'memberProfits'
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  border: Border.all(color: yellowborder),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  children: [

                                    Container(
                                      height: 40,
                                      width: 165,
                                      color: golden,
                                      child: Center(
                                        child: Text(
                                          profilepagestatus != null &&
                                              profilepagestatus
                                                  .containsKey('memberProfits')
                                              ? profilepagestatus['memberProfits']
                                          [index]['packageName']
                                              : '',
                                          // Check again before accessing nested keys
                                          style: TextStyle(
                                              fontSize: 10, color: textblack),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(
                                              "Members",
                                              style: TextStyle(fontSize: 10,color: white),
                                            ),
                                            Text(
                                              profilepagestatus != null &&
                                                  profilepagestatus
                                                      .containsKey(
                                                      'memberProfits')
                                                  ? profilepagestatus[
                                              'memberProfits']
                                              [index]['usersCount']
                                                  .toString()
                                                  : '',
                                              // Check again before accessing nested keys
                                              style: TextStyle(fontSize: 12,color: white),
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          color: white,
                                          thickness: .2,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(
                                              "Amount",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: white
                                              ),
                                            ),
                                            Text(
                                              profilepagestatus != null &&
                                                  profilepagestatus
                                                      .containsKey(
                                                      'memberProfits')
                                                  ? profilepagestatus[
                                              'memberProfits']
                                              [index]['splitAmount']
                                                  .toString()
                                                  : '',
                                              // Check again before accessing nested keys
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Team Performance",style: TextStyle(color: white),)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: teamperformacestatus != null &&
                      teamperformacestatus.containsKey('rankData')
                      ? teamperformacestatus['rankData'].length
                      : 0,
                  // Check if profilepagestatus is not null and contains 'memberProfits'
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 100,
                                width: 165,
                                decoration: BoxDecoration(
                                  border: Border.all(color: yellowborder),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  children: [

                                    Container(
                                      height: 40,
                                      width: 165,
                                      color: golden,
                                      child: Center(
                                        child: Text(
                                          teamperformacestatus != null &&
                                              teamperformacestatus
                                                  .containsKey('rankData')
                                              ? teamperformacestatus['rankData']
                                          [index]['rankName'].toString().toUpperCase()
                                              : '',
                                          // Check again before accessing nested keys
                                          style: TextStyle(
                                              fontSize: 10, color: textblack),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(
                                              "Members",
                                              style: TextStyle(fontSize: 10,color: white),
                                            ),
                                            Text(
                                              teamperformacestatus != null &&
                                                  teamperformacestatus
                                                      .containsKey(
                                                      'rankData')
                                                  ? teamperformacestatus[
                                              'rankData']
                                              [index]['usersCount']
                                                  .toString()
                                                  : '',
                                              // Check again before accessing nested keys
                                              style: TextStyle(fontSize: 12,color: white),
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          color: white,
                                          thickness: .2,
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(
                                              "Amount",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: white
                                              ),
                                            ),
                                            Text(
                                              teamperformacestatus != null &&
                                                  teamperformacestatus
                                                      .containsKey(
                                                      'rankData')
                                                  ? teamperformacestatus[
                                              'rankData']
                                              [index]['monthlyDivident']
                                                  .toString()
                                                  : '',
                                              // Check again before accessing nested keys
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 10,),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            //   child: Align(
            //       alignment: Alignment.topLeft,
            //       child: Text("Team Performance income",style: TextStyle(color: white),)),
            // ),
            //
            // Padding(
            //   padding: const EdgeInsets.only(left: 20),
            //   child: SizedBox(
            //     height: 120,
            //     child: ListView.builder(
            //       itemCount: profilepagestatus != null &&
            //           profilepagestatus.containsKey('memberProfits')
            //           ? profilepagestatus['memberProfits'].length
            //           : 0,
            //       // Check if profilepagestatus is not null and contains 'memberProfits'
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (BuildContext context, int index) {
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10),
            //           child: Row(
            //             children: [
            //               Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   SizedBox(
            //                     height: 5,
            //                   ),
            //                   Container(
            //                     height: 100,
            //                     width: 165,
            //                     decoration: BoxDecoration(
            //                       border: Border.all(color: yellowborder),
            //                       borderRadius:
            //                       BorderRadius.all(Radius.circular(5)),
            //                     ),
            //                     child: Column(
            //                       children: [
            //
            //                         Container(
            //                           height: 40,
            //                           width: 165,
            //                           color: golden,
            //                           child: Center(
            //                             child: Text(
            //                               profilepagestatus != null &&
            //                                   profilepagestatus
            //                                       .containsKey('memberProfits')
            //                                   ? profilepagestatus['memberProfits']
            //                               [index]['packageName']
            //                                   : '',
            //                               // Check again before accessing nested keys
            //                               style: TextStyle(
            //                                   fontSize: 10, color: textblack),
            //                             ),
            //                           ),
            //                         ),
            //                         Row(
            //                           crossAxisAlignment:
            //                           CrossAxisAlignment.center,
            //                           mainAxisAlignment: MainAxisAlignment.center,
            //                           children: [
            //                             Column(
            //                               children: [
            //                                 SizedBox(height: 10,),
            //                                 Text(
            //                                   "Members",
            //                                   style: TextStyle(fontSize: 10,color: white),
            //                                 ),
            //                                 Text(
            //                                   profilepagestatus != null &&
            //                                       profilepagestatus
            //                                           .containsKey(
            //                                           'memberProfits')
            //                                       ? profilepagestatus[
            //                                   'memberProfits']
            //                                   [index]['usersCount']
            //                                       .toString()
            //                                       : '',
            //                                   // Check again before accessing nested keys
            //                                   style: TextStyle(fontSize: 12,color: white),
            //                                 ),
            //                               ],
            //                             ),
            //                             VerticalDivider(
            //                               color: white,
            //                               thickness: .2,
            //                             ),
            //                             Column(
            //                               children: [
            //                                 SizedBox(height: 10,),
            //                                 Text(
            //                                   "Amount",
            //                                   style: TextStyle(
            //                                       fontSize: 10,
            //                                       color: white
            //                                   ),
            //                                 ),
            //                                 Text(
            //                                   profilepagestatus != null &&
            //                                       profilepagestatus
            //                                           .containsKey(
            //                                           'memberProfits')
            //                                       ? profilepagestatus[
            //                                   'memberProfits']
            //                                   [index]['splitAmount']
            //                                       .toString()
            //                                       : '',
            //                                   // Check again before accessing nested keys
            //                                   style: TextStyle(
            //                                     fontSize: 12,
            //                                     color: white,
            //                                     fontWeight: FontWeight.w700,
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            //
            // SizedBox(height: 10,),


            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => withdrawalpage()));
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
                        Center(child: Text("Withdraw Amount",style: TextStyle(fontSize: 14,color: white),)),

                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20,),

            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            TransactionHistory(id:  profiledetails?['user']?['_id'],)));
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
                          Center(child: Text("Transaction History",style: TextStyle(fontSize: 14,color: white),)),

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

            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}