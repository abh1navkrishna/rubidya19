import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_Inner_Details.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSixGridviewall extends StatefulWidget {
  @override
  _TopSixGridviewall createState() => _TopSixGridviewall();
}

class _TopSixGridviewall extends State<TopSixGridviewall> {


  String _selectedDropdownValue = 'Thisday';
  var trendingthisalltopsix;
  bool _isLoading = true;



  Future _trendingtopSixapithisall(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.trendingapiThisallmore();
      log.i('tranding by all .. $response');
      setState(() {
        trendingthisalltopsix = response;
      });
    } catch (e) {
      // Handle error appropriately here
      print('Error in _trendingtopSixapi: $e');
    }
  }







  Future _initLoad() async {
    try {
      await Future.wait([
        _trendingtopSixapithisall(_selectedDropdownValue),


      ]);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Initialization error: $e');
      // Handle initialization errors here
    }
  }


  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        :GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // Number of items per row
        crossAxisSpacing: 5.0,
        // Horizontal space between items
        mainAxisSpacing: 5.0,
        // Vertical space between items
        childAspectRatio:
        0.6, // Aspect ratio of each item
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrendingInnerPage(id: trendingthisalltopsix['response'][index]['_id'],dayidentifier: 'thisall')),);
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 10),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width:0.5),
                color: blueshade,
                borderRadius:
                BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.0),
                        // Adjust padding as needed
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/image/congratulation.png",
                          height: 90,
                          width: 90,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        // Adjust position as needed
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 0.5,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueshade,
                          border: Border.all(
                              width: 5, color: bluetext),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: bluetext,
                          backgroundImage:
                          trendingthisalltopsix['response'][index]
                          ['profilePic'] !=
                              null
                              ? NetworkImage(
                              trendingthisalltopsix['response']
                              [index]['profilePic'])
                              : null,
                          child: trendingthisalltopsix['response'][index]
                          ['profilePic'] ==
                              null
                              ? Icon(Icons.person,
                              size: 30,
                              color: Colors
                                  .white) // Optionally add an icon or placeholder
                              : null,
                        ),
                      ),
                      Positioned(
                        top: 70,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: gradnew,
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(100)),
                          ),
                          child: Center(
                            child: Text(
                              trendingthisalltopsix['response'][index]['rank'].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                  Container(
                    height: 15,
                    child: Text(
                      trendingthisalltopsix['response'][index]['userName'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis, // Ensures text overflow is handled
                      maxLines: 1, // Limits the text to a single line
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        'Points:',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        trendingthisalltopsix['response'][index]['totalPoints'].toString(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 20,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bluetext,
                      borderRadius: BorderRadius.all(
                          Radius.circular(8)),
                    ),
                    child: Text(
                      "Good job",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}