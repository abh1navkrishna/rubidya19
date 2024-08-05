import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../resources/color.dart';
import '../../../../services/home_service.dart';
import '../../../../services/wallet_service.dart';
import '../../../../support/logger.dart';

class TransactionHistory extends StatefulWidget {
  TransactionHistory({Key? key, required this.id}) : super(key: key);

  final String? id;

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  int _pageNumber = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _isLoading = true;
  List<dynamic> _transactionHistory = [];

  var userid;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        _loadMoreData(),
      ],
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final response = await WalletService.TransactionHistory(
        widget.id,
        page: _pageNumber,
        limit: 10,
      );
      final newTransactions = response['result'];
      setState(() {
        _pageNumber++;
        _isLoadingMore = false;
        _transactionHistory.addAll(newTransactions);
        if (newTransactions.length < 10) {
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
        if (!_isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreData();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          title: Text("Transaction history", style: TextStyle(fontSize: 14)),
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _transactionHistory.length + 1,
                itemBuilder: (context, index) {
                  if (index == _transactionHistory.length) {
                    return _isLoadingMore
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : SizedBox();
                  }
                  final transaction = _transactionHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: lightpink,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/svg/transaction.svg",
                                  height: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 35),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['typeofTransaction'] ?? '',
                                  style: TextStyle(fontSize: 14, color: tranactionclr, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  transaction['fromWhom'] ?? '',
                                  style: TextStyle(fontSize: 10, color: bluetext),
                                ),
                                Text(
                                  transaction['kind'] ?? '',
                                  style: TextStyle(fontSize: 8, color: appBlueColor),
                                ),
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              transaction['amount'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: transaction['amount'] == null ? Colors.grey : bluetext,
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
          ],
        ),
      ),
    );
  }
}
