import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/trending_service.dart';

class TrendingInnerPage extends StatefulWidget {
  TrendingInnerPage({super.key, required this.id, required this.dayidentifier});
  final String id;
  final String dayidentifier;

  @override
  State<TrendingInnerPage> createState() => _TrendingInnerPageState();
}

class _TrendingInnerPageState extends State<TrendingInnerPage> {
  var userid;
  var trendingdayInner;
  bool _isLoading = true;

  Future _profileInner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    var response;
    if (widget.dayidentifier == 'thisday') {
      response = await TrendingService.trendingallpointsthisday(widget.id);
    } else if (widget.dayidentifier == 'thisweek') {
      response = await TrendingService.trendingallpointsthisweek(widget.id);
    } else if (widget.dayidentifier == 'thismonth') {
      response = await TrendingService.trendingallpointsthismonth(widget.id);
    } else if (widget.dayidentifier == 'thisyear') {
      response = await TrendingService.trendingallpointsthismonth(widget.id);
    }
    else if (widget.dayidentifier == 'thisall') {
      response = await TrendingService.trendingallpointsthisall(widget.id);
    }else {
      throw Exception('Invalid day identifier: ${widget.dayidentifier}');
    }


    setState(() {
      trendingdayInner = response;
    });
  }

  Future _initLoad() async {
    await _profileInner();
    setState(() {
      _isLoading = false;
    });
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
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: Text(
          trendingdayInner != null && trendingdayInner.containsKey('userName')
              ? trendingdayInner['userName']
              : 'Unknown',
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),
      body: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: trendingdayInner?['userProfilePic'] != null
                  ? Image.network(
                trendingdayInner['userProfilePic'],
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              )
                  : Icon(Icons.person,
                  size: 60, color: Colors.grey), // Fallback icon
            ),
          ),
          SizedBox(height: 10),
          Text(
            trendingdayInner?['userName'] ?? 'Unknown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors
                  .white, // Ensure you use Colors.white if white is not defined
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Points  :  ",
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: white),
              ),
              Text(
                trendingdayInner?['fullPoint']?.toString() ??
                    '0', // Default to '0' if null
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors
                      .white, // Ensure you use Colors.white if white is not defined
                ),
              ),
            ],
          ),

          SizedBox(height: 10),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 0.0, // Horizontal spacing between items
                  mainAxisSpacing: 10.0, // Vertical spacing between items
                  childAspectRatio: 1.0,

                ),
                itemCount: trendingdayInner?['response']?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff3C62CD),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: blueshade.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            trendingdayInner?['response']?[index]?['pointType'] ??
                                'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors
                                  .white, // Ensure you use Colors.white if white is not defined
                            ),
                          ),
                          Text(
                            trendingdayInner?['response']?[index]?['totalPoints']
                                ?.toString() ??
                                '0', // Default to '0' if null
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors
                                  .white, // Ensure you use Colors.white if white is not defined
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}