import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/success_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/color.dart';
import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';

class TransferToRubediumExchange extends StatefulWidget {
  const TransferToRubediumExchange({super.key});

  @override
  State<TransferToRubediumExchange> createState() => _TransferRubidiumWalletState();
}

class _TransferRubidiumWalletState extends State<TransferToRubediumExchange> {


  var profiledetails;
  var userid;
  bool _isLoading = true;
  var amount;


  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }



  Future<void> Sendmoney() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'amount': amount,
      };

      var response = await ProfileService.sendmoney(reqData);
      print('Withdrawal response: $response');

      if (response['sts'] == '01') {
        // Successful transfer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Money Transferred successfully'),
            duration: Duration(seconds: 3),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => successpage()),
        );

      } else {
        // Unsuccessful transfer
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['msg']),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');

      // Show error message based on specific error cases
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sorry,you dont have enough wallet amount to transfer'),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
    return Scaffold(
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
      body:  _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :Column(
        children: [

          SizedBox(height: 20,),


          Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              width: 345,
              height: 177,
              duration: Duration(milliseconds: 0),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.white, width: 0.2),
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
                    Column(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Text("Wallet Amount", style: TextStyle(fontSize: 12, color: Colors.white))),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Image.asset(
                              "assets/logo/logowt.png",
                              height: 30,
                            ),
                            Text(profiledetails?['user']?['walletAmount']?.toString() ?? 'Loading...', style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),



                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 30,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              // controller: _amountController, // Use the TextEditingController
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your amount ',
                hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white, width: .2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white,width: .3),

                ),
              ),
              onChanged: (text) {
                setState(() {
                  amount = text;
                });
              },
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          SizedBox(height: 20),




          InkWell(
            onTap: (){
              Sendmoney();
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
                  child: Center(child: Text("Send",style: TextStyle(fontSize: 14,color: white),))
              ),
            ),
          ),

        ],
      ),
    );
  }
}
