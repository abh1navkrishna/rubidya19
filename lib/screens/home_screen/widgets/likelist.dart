import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import '../../profile_screen/inner_page/profile_inner_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Like_List extends StatefulWidget {
  final String id;

  const Like_List({super.key, required this.id});

  @override
  State<Like_List> createState() => _Like_ListState();
}

class _Like_ListState extends State<Like_List> {
  bool isExpanded = false;
  var userid;
  List<dynamic> likeList = [];
  List<dynamic> filteredLikeList = [];
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _isLastPage = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  Future<void> _fetchLikes({bool reset = false}) async {
    if (_isFetchingMore) return;
    if (reset) {
      setState(() {
        _currentPage = 1;
        _isLastPage = false;
        likeList.clear();
        filteredLikeList.clear();
      });
    }
    if (_isLastPage) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('_id');
      var response = await HomeService.likelist(widget.id, page: _currentPage);

      if (response['status'] == '01' && response['msg'] == 'Success') {
        setState(() {
          likeList.addAll(response['result']);
          _applySearchFilter();
          if (response['result'].length < 10) {
            _isLastPage = true;
          }
          _currentPage++;
        });
      } else {
        print('Failed to fetch likes: ${response['msg']}');
      }
    } catch (e) {
      print('Error fetching likes: $e');
    } finally {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  void _applySearchFilter() {
    setState(() {
      filteredLikeList = likeList
          .where((likeItem) =>
          '${likeItem['firstName']} ${likeItem['lastName']}'
              .toLowerCase()
              .contains(_searchTerm.toLowerCase()))
          .toList();
    });
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      if (filteredLikeList[index]['isFollowing'] != null) {
        filteredLikeList[index]['isFollowing'] =
        !filteredLikeList[index]['isFollowing'];
      }
    });

    var followerId = filteredLikeList[index]['_id'];
    if (filteredLikeList[index]['isFollowing'] != null &&
        filteredLikeList[index]['isFollowing']) {
      await follow(followerId);
    } else {
      await unfollow(followerId);
    }
  }

  Future<void> follow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }

  Future<void> unfollow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.unfollow(reqData);
    log.i('removed from follow. $response');
  }

  @override
  void initState() {
    super.initState();
    _fetchLikes();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
        _applySearchFilter();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Likes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.grey),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: buttoncolor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: const OutlineInputBorder()),
            ),
          ),
          Expanded(
            child: filteredLikeList.isNotEmpty
                ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                    !_isFetchingMore) {
                  _fetchLikes();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: filteredLikeList.length + 1,
                itemBuilder: (context, index) {
                  if (index == filteredLikeList.length) {
                    return _isFetchingMore
                        ? Center(child: CupertinoActivityIndicator())
                        : SizedBox.shrink();
                  }
                  var likeItem = filteredLikeList[index];
                  String profilePicUrl =
                  (likeItem['profilePic'] ?? '').toString();
                  bool isValidUrl =
                      Uri.tryParse(profilePicUrl)?.isAbsolute ?? false;

                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => profileinnerpage(
                                  id: likeItem['_id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: CircleAvatar(
                              backgroundImage: isValidUrl &&
                                  likeItem['profilePic'] != null
                                  ? NetworkImage(likeItem['profilePic'])
                                  : null,
                              child: !isValidUrl ||
                                  likeItem['profilePic'] == null
                                  ? Image.network(
                                  "https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8")
                                  : null,
                              radius: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          profileinnerpage(
                                            id: likeItem['_id'],
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.5,
                                  child: Text(
                                    '${likeItem['firstName']} ${likeItem['lastName']}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => toggleFollow(index),
                                child: Container(
                                  height: 25,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5),
                                    color: likeItem['isFollowing']
                                        ? Colors.grey
                                        : buttoncolor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      likeItem['isFollowing']
                                          ? 'Unfollow'
                                          : 'Follow',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
                : Center(child: Text('No users found')),
          ),
        ],
      ),
    );
  }
}