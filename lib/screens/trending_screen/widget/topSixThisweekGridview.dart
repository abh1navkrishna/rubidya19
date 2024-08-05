import 'package:flutter/material.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/trending_screen/widget/trending_Inner_Details.dart';
import 'package:rubidya/services/trending_service.dart';
import 'package:rubidya/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSixGridviewweek extends StatefulWidget {
  @override
  _TopSixGridviewday createState() => _TopSixGridviewday();
}

class _TopSixGridviewday extends State<TopSixGridviewweek> {
  String _selectedDropdownValue = 'Thisday';
  var trendingthisweektopsix;
  bool _isLoading = true;

  var trendingalltimepoints;

  Future _trendingtopSixapithisweek(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString('userid');
    try {
      var response = await TrendingService.trendingapiThisweek();
      log.i('tranding by days .. $response');
      setState(() {
        trendingthisweektopsix = response;
      });
    } catch (e) {
      print('Error in _trendingtopSixapi: $e');
    }
  }


  Future<int> _fetchfullpoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      return response['fullPoint'];  // Assuming the API response contains the 'likes' field
    } catch (e) {
      print('Error fetching likes: $e');
      return 0;  // Default to 0 if there's an error
    }
  }





  Future<int> _fetchfirstCommentPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'comment',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching comment points: $e');
      return 0; // Default to 0 if there's an error
    }
  }


  Future<int> _fetchRefferalPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'referal',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }



  Future<int> _fetchPostPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'referal',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }





  Future<int> _fetchFirst_Points(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'first_post',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching referal points: $e');
      return 0; // Default to 0 if there's an error
    }
  }


  Future<int> _fetchfollow_Points(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'follow',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
    }
  }




  Future<int> _fetchCommentPoints(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'comment',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
    }
  }



  Future<int> _fetchLikes(String userId) async {
    try {
      var response = await TrendingService.trendingallpointsthisweek(userId);
      // Assuming the response is a JSON map and contains a list of points
      List<dynamic> points = response['response']; // Adjust based on actual API response structure

      // Find the points of type "comment"
      var commentPoints = points.firstWhere(
            (point) => point['pointType'] == 'like',
        orElse: () => null,
      );

      // Return the totalPoints if found, otherwise return 0
      if (commentPoints != null) {
        return commentPoints['totalPoints'];
      } else {
        return 0; // Default to 0 if no comment points are found
      }
    } catch (e) {
      print('Error fetching follow points: $e');
      return 0; // Default to 0 if there's an error
    }
  }

  Future _initLoad() async {
    try {
      await Future.wait([
        _trendingtopSixapithisweek(_selectedDropdownValue),
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
        : GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrendingInnerPage(id: trendingthisweektopsix['response'][index]['_id'],dayidentifier: "thisweek")),);
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                color: blueshade,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            border: Border.all(width: 0.5, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueshade,
                          border: Border.all(width: 5, color: bluetext),
                        ),
                        child:CircleAvatar(
                          radius: 30,
                          backgroundColor: bluetext,
                          backgroundImage:
                          trendingthisweektopsix['response'][index]
                          ['profilePic'] !=
                              null
                              ? NetworkImage(
                              trendingthisweektopsix['response']
                              [index]['profilePic'])
                              : null,
                          child: trendingthisweektopsix['response'][index]
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
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Center(
                            child: trendingthisweektopsix != null && trendingthisweektopsix['response'] != null && trendingthisweektopsix['response'][index] != null
                                ? Text(
                              trendingthisweektopsix['response'][index]['rank'].toString(),
                              style: TextStyle(color: Colors.white, fontSize: 8),
                            )
                                : Text(
                              '-',  // Display a placeholder or handle the null case
                              style: TextStyle(color: Colors.white, fontSize: 8),
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
                      trendingthisweektopsix['response'][index]['userName'],
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        trendingthisweektopsix['response'][index]['totalPoints'].toString(),
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
                      borderRadius: BorderRadius.all(Radius.circular(8)),
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