import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/success_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/color.dart';
import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';

class TransferRubidiumWallet extends StatefulWidget {
  const TransferRubidiumWallet({super.key});

  @override
  State<TransferRubidiumWallet> createState() => _TransferRubidiumWalletState();
}

class _TransferRubidiumWalletState extends State<TransferRubidiumWallet> {


  var profiledetails;
  var userid;
  bool _isLoading = true;
  bool isLoading = false;
  String deductedAmount = '';
  String deductedmsg = '';

  String? indianRupee;
  String? mobilenumber;
  bool isAmountGreaterThanWallet = false;

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



  Future<void> withdrawal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      var reqData = {
        'amount': deductedAmount,
        'recievresNo': mobilenumber,
      };

      var response = await ProfileService.withdraw(reqData);
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

        setState(() {
          deductedAmount = response['convertedAmount'].toString();
          deductedmsg = response['msg'].toString();
        });
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
          content: Text('User not found to transfer"'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }


  Future convertinr() async {
    setState(() {});
    try {
      setState(() {});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');

      // String packageamount = widget.amount ?? ''; // Initialize 'amount' here

      var reqData = {
        'amount': indianRupee,
      };

      var response = await ProfileService.convertinr(reqData);
      log.i('Done deducting.... . $response');

      if (response['sts'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully Sync..'),
            duration: Duration(seconds: 3),
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => successpage()),
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
      if (error.toString().contains('Erorr deducting')) {
        // Show a SnackBar to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found to transfer'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  bool validateForm() {
    if (mobilenumber == null || mobilenumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid mobile number'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
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
    super.initState();
    setState(() {
      _initLoad();

      });
  }

  // bool isAmountValid() {
  //   if (indianRupee == null || indianRupee!.isEmpty) {
  //     return false;
  //   }
  //   double enteredAmount = double.tryParse(indianRupee!) ?? 0;
  //   double walletAmount = double.tryParse(profiledetails['user']['walletAmount'].toString()) ?? 0;
  //   return enteredAmount <= walletAmount;
  // }


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
                            Text(profiledetails['user']['walletAmount'].toString(), style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.w700)),
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
                hintText: 'Enter your Amount',
                hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white, width: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white, width: 0.3),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '₹', // Indian Rupee symbol
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: (){
                    setState(() {
                      convertinr();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Colors.red , // Change color based on validity
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          "Sync",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  indianRupee = text;
                });
              },
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),



          SizedBox(height: 20,),

          if (deductedAmount.isNotEmpty)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  // controller: _amountController, // Use the TextEditingController
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
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
                      mobilenumber = text;
                    });
                  },
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

              SizedBox(height: 20,),
            
              
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 40,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: white,width: .3)
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    child: Text(
                      ' ${deductedAmount.isEmpty ? "0" : deductedAmount}',
                      style: TextStyle(
                          color: white,
                          fontSize: 18),
                    ),
                  ),
                ),

              )


            ],
          ),


          SizedBox(height: 20),
          if (deductedAmount.isNotEmpty)
          InkWell(
            // onTap: (){
            //   setState(() {
            //
            //     withdrawal();
            //
            //   });
            // },

            onTap: () {
              if (validateForm()) {
                // Set isLoading to true to show the loader
                setState(() {
                  isLoading = true;
                });

                // Perform your asynchronous operation, for example, createleave()
                withdrawal().then((result) {
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
