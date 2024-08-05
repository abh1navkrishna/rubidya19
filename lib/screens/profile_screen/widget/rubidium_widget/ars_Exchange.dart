import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/color.dart';
import '../../../../services/profile_service.dart';
import '../../../../support/logger.dart';
import 'package:easy_debounce/easy_debounce.dart';

import 'my_wallet.dart';

class RubidyaExchange extends StatefulWidget {
  const RubidyaExchange({Key? key}) : super(key: key);

  @override
  State<RubidyaExchange> createState() => _RubidyaExchangeState();
}

class _RubidyaExchangeState extends State<RubidyaExchange> {
  bool _isLoading = true;
  String? amount;
  var profileData;
  late String userId;
  bool isLoading = false;

  final TextEditingController _amountController = TextEditingController();

  Future<void> addMoney() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userid') ?? '';
      var reqData = {'amount': amount};

      var response = await ProfileService.addAmountTopUP(reqData);
      log.i('Top-up successful. $response');

      // Update profile details after successful top-up
      await _fetchProfileDetails();

      // Show success message or navigate to another screen if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Amount added successfully!'),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        amount = null; // Clear the amount field
        _amountController.clear(); // Clear the text field
      });
    } catch (error) {
      // Handle specific error cases
      if (error.toString().contains("Amount send Failed")) {
        // Show a SnackBar or AlertDialog to inform the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Insufficient balance'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Handle other errors or rethrow them if not handled here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add amount. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _fetchProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userid') ?? '';
    var response = await ProfileService.getProfile();
    log.i('Profile details retrieved: $response');
    setState(() {
      profileData = response;
    });
  }

  void _handleTap() {
    if (validateForm()) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      addMoney().then((_) {
        // Hide loading indicator after adding money
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  bool validateForm() {
    if (amount == null || amount!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter an amount'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _initLoad() async {
    await Future.wait(
      [
        _fetchProfileDetails(),
      ],
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _amountController.text = amount ?? ''; // Set initial text for TextField
    _initLoad(); // Initialize widget state
  }

  @override
  void dispose() {
    _amountController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: Text(
          "Rubidya Exchange",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        leading: CupertinoNavigationBarBackButton(
          color: white,
          previousPageTitle: "", // Optional: Specify the previous page title
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyWallet()));
          },
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 177,
                  width: 345,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Available balance",
                        style:
                        TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/logo/logowt.png",
                            height: 30,
                          ),
                          SizedBox(width: 5),
                          Text(
                            profileData?['user']?['walletAmount']
                                ?.toString() ??
                                'Loading...',
                            style: TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _amountController, // Use the TextEditingController
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your Amount',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Image.asset(
                    "assets/logo/logowt1.png",
                    height: 20,
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
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: isLoading
                    ? null
                    : () {
                  // Check form validation before proceeding with tap action
                  if (validateForm()) {
                    // If form validation passes, handle the tap action
                    _handleTap();
                  }
                },
                child: Container(
                  height: 40,
                  width: 400,
                  decoration: BoxDecoration(
                    color: bluetext,
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      "PROCEED TO TOPUP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
