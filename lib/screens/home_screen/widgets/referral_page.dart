import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class referralpage extends StatefulWidget {
  const referralpage({Key? key}) : super(key: key);

  @override
  State<referralpage> createState() => _referralpageState();
}

class _referralpageState extends State<referralpage> {
  int _pageNumber = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  List<dynamic> _referrals = [];

  var userid;
  var profiledetails;
  String balance = '';

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await Future.wait([
      _profiledetailsapi(),
      fetchBalance(),
      _loadMoreData(),
    ]);
  }

  Future<void> _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future<void> fetchBalance() async {
    final url = 'https://pwyfklahtrh.rubideum.net/basic/getBalance';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "payId": "RBD968793034",
        "uniqueId": "64eaf0a9cec8b5bb72f56d01",
        "currency": "RBD",
      }),
    );

    print(profiledetails?['user']?['payId'] ?? '');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        balance = data['balance'].toString();
      });
    } else {
      // Handle error
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await HomeService.getDirectReferrals(
        page: _pageNumber,
        limit: 10,
      );

      final newReferrals = response['referrals'];
      setState(() {
        _pageNumber++;
        _isLoadingMore = false;
        _referrals.addAll(newReferrals);

        if (newReferrals.length < 10) {
          _hasMore = false;
        }
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoadingMore &&
            scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
          _loadMoreData();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 0.1,
          backgroundColor: white,
          title: Text("Referral History",style: TextStyle(fontSize: 14),),
        ),
        // backgroundColor: bluetext,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 177,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        "Referral Balance",
                        style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w300),
                      ),
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
                          Text(
                            profiledetails?['user']?['totalReferralAmount'].toString() ?? '',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: white),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: () {
                          Share.share("https://admin.rubidya.com/register/$userid");
                        },
                        child: Container(
                          height: 36,
                          width: 130,
                          decoration: BoxDecoration(
                            border: Border.all(color: white, width: .2),
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
                              Text(
                                "REFER NOW",
                                style: TextStyle(fontSize: 10, color: white, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10,),
                              SvgPicture.asset(
                                "assets/svg/arrow.svg",
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Referral History",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: bluetext),)),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _referrals.length,
                  itemBuilder: (BuildContext context, int index) {
                    final referral = _referrals[index];
                    final transactions = referral['transactions'] as List<dynamic>;

                    // Calculate total amount from transactions if available
                    double totalAmount = 0.0;
                    if (transactions.isNotEmpty) {
                      totalAmount = transactions.isNotEmpty
                          ? transactions
                          .map((transaction) => (transaction['amount'] is int)
                          ? (transaction['amount'] as int).toDouble()
                          : transaction['amount'] as double)
                          .reduce((sum, amount) => sum + amount)
                          : 0.0;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: SvgPicture.asset(
                                  "assets/svg/circlearrow.svg",
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                referral['firstName'],
                                style: TextStyle(fontSize: 14, color: bluetext),
                              ),

                              Expanded(child: SizedBox()),

                              Text(
                                transactions.isEmpty
                                    ? 'No Transactions'
                                    : ' ${totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: transactions.isEmpty ? Colors.grey : bluetext,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: bluetext, thickness: .1),
                        ],
                      ),
                    );
                  },
                ),

              ),
              _isLoadingMore
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
