import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import '../../chat_screen/chatpage.dart';
import '../../home_screen/widgets/comment_home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'follower_inner_list.dart';
import 'following_inner_list.dart';

class profileinnerpage extends StatefulWidget {
  profileinnerpage({
    super.key,
    required this.id,
  });

  String? id;

  @override
  State<profileinnerpage> createState() => _profileinnerpageState();
}

class _profileinnerpageState extends State<profileinnerpage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var userid;
  var profileinnerpageshow;
  bool isLoading = false;
  bool _isLoading = true;
  bool _isMoreLoading = false;
  String? imageUrl;
  bool isFollowing = false;
  bool isBlocked = false;
  final fallbackImageUrl = 'https://pbs.twimg.com/media/CidJXBuUUAEgAYu.jpg';
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  void _toggleFollow() async {
    setState(() {
      isFollowing = !isFollowing;
    });

    if (isFollowing) {
      await _Follow();
    } else {
      await _UnFollow();
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isMoreLoading) {
      _loadMore();
    }
  }

  Future<void> _profileInner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.Profileinnerpage(widget.id);

    if (response != null && response['media'] != null) {
      bool initialFollowStatus = response['media'][0]['isFollowing'];
      bool initialBlockStatus =
          response['media'][0]['isBlocked'] ?? false; // Add null check here

      setState(() {
        isFollowing = initialFollowStatus;
        isBlocked = initialBlockStatus; // Add this line
        profileinnerpageshow = response;
      });
    }
  }

  Future<void> _Follow() async {
    var reqData = {'followerId': widget.id};
    var response = await HomeService.follow(reqData);
    log.i('add to Follow. $response');
  }

  Future<void> _UnFollow() async {
    var reqData = {'followerId': widget.id};
    var response = await HomeService.unfollow(reqData);
    log.i('add to UnFollow. $response');
  }

  Future<void> _initLoad() async {
    await Future.wait([_profileInner()]);
    setState(() {
      _isLoading = false;
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _initLoad();
    super.initState();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isMoreLoading = true;
      _pageNumber++;
    });

    var response = await ProfileService.getProfileimage(page: _pageNumber);
    log.i('Profile Image Loading........: $response');
    setState(() {
      if (profileinnerpageshow == null) {
        profileinnerpageshow = response;
      } else {
        profileinnerpageshow['media'].addAll(response['media']);
      }
      _isMoreLoading = false;
    });
  }

  Future<void> blockUser() async {
    var reqData = {'user': widget.id};
    var response = await ProfileService.blockuser(reqData);
    log.i('User blocked: $response');
    setState(() {
      isBlocked = true;
    });
  }

  Future<void> unblockUser() async {
    var reqData = {'user': widget.id};
    var response = await ProfileService.unblockuser(reqData);
    log.i('User unblocked: $response');
    setState(() {
      isBlocked = false;
    });
  }

  Future<void> reportUser(String description, BuildContext context) async {
    var reqData = {
      'user': widget.id,
      'description': description,
    };
    var response = await ProfileService.reportuser(reqData);
    log.i('User Reported: $response');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['msg'] ?? 'Something went wrong'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    TextEditingController _reportController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
          height: 400.0,
          width: 400.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Report User",
                  style: TextStyle(
                    color: bluetext,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "What Do You Want to Report",
                  style: TextStyle(
                    color: blueshade,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _reportController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:
                        "With the exception of reporting an infringement of intellectual property, your report is anonymous. Make a quick call to the local emergency services if someone is in danger.",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 50.0,
                  child: GestureDetector(
                    onTap: () {
                      String reportText = _reportController.text;
                      reportUser(
                          reportText, context); // Ensure context is correct
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bluetext,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'Report User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userId = profileinnerpageshow['media']?[0]['id'] ?? '';
    String conversationId = profileinnerpageshow['media']?[0]['id'] ?? '';
    String username = profileinnerpageshow['media']?[0]['firstName'] ?? '';
    String profilepicc = profileinnerpageshow['media']?[0]['pr'] ?? '';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          (profileinnerpageshow?['media']?[0]['firstName'] ?? 'loading...'),
          style: TextStyle(fontSize: 14),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      height: 400.0,
                      width: 400.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(profileinnerpageshow[
                                    'media'][0][
                                'profilePic']), // Replace with the actual URL of the profile photo
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            (profileinnerpageshow?['media']?[0]['firstName'] ??
                                'loading...'),
                            style: TextStyle(
                              color: bluetext,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.block, // This is the block icon
                                  size: 30.0,
                                  color: bluetext, // Adjust the size as needed
                                ),
                                SizedBox(
                                    width:
                                        4.0), // Optional: add some space between the icon and the text
                                Expanded(
                                  child: Text(
                                    " They won't be able to message you through\n Rubidya, access your profile, or find any of your content",
                                    style: TextStyle(
                                      color: bluetext,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .notifications_off_outlined, // This is the block icon
                                  size: 30.0,
                                  color: bluetext, // Adjust the size as needed
                                ),
                                SizedBox(
                                    width:
                                        4.0), // Optional: add some space between the icon and the text
                                Expanded(
                                  child: Text(
                                    " They won't be informed that you have blocked them",
                                    style: TextStyle(
                                      color: bluetext,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () async {
                              if (isBlocked) {
                                await unblockUser();
                              } else {
                                await blockUser();
                              }
                              Navigator.pop(context); // Close the modal
                            },
                            child: Container(
                              height: 40,
                              width: 350,
                              decoration: BoxDecoration(
                                color: bluetext,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  isBlocked ? "Unblock" : "Block",
                                  style: TextStyle(fontSize: 10, color: white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(
                                  context); // Close the current bottom sheet
                              _showReportSheet(
                                  context); // Show the new bottom sheet
                            },
                            child: Text(
                              "Report User",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.more_horiz),
            ),
          ),
        ],
        backgroundColor: white,
      ),
      backgroundColor: white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle the image tap event here
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FullScreenImage(
                                              imageUrl:
                                                  profileinnerpageshow['media']
                                                      [0]['profilePic']),
                                        ));
                                    if (profileinnerpageshow != null &&
                                        profileinnerpageshow['media'] != null &&
                                        profileinnerpageshow['media']
                                            .isNotEmpty &&
                                        profileinnerpageshow['media'][0]
                                                ['profilePic'] !=
                                            null) {
                                      // Navigate to the image viewing page or perform any other action
                                      print("Image tapped!");
                                    } else {
                                      // Handle the case when there's no image
                                      print("No image to display.");
                                    }
                                  },
                                  child: profileinnerpageshow != null &&
                                          profileinnerpageshow['media'] !=
                                              null &&
                                          profileinnerpageshow['media']
                                              .isNotEmpty &&
                                          profileinnerpageshow['media'][0]
                                                  ['profilePic'] !=
                                              null
                                      ? SizedBox(
                                          width: 90,
                                          height: 90,
                                          child: Image.network(
                                            profileinnerpageshow['media'][0]
                                                ['profilePic'],
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Center(
                                          child: Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: grad2,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "No Img",
                                                style: TextStyle(color: greybg),
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 250.0,
                        height: 64.0,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  (profileinnerpageshow?['media']?[0]['post']
                                          .toString() ??
                                      'loading...'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: bluetext,
                                  ),
                                ),
                                Text("Post",
                                    style: TextStyle(
                                        fontSize: 10, color: bluetext))
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Followerinnerlist(
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                      (profileinnerpageshow?['media']?[0]
                                                  ['followers']
                                              .toString() ??
                                          'loading...'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: bluetext)),
                                  Text("Followers",
                                      style: TextStyle(
                                          fontSize: 10, color: bluetext))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Followinginnerpage(
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                      (profileinnerpageshow?['media']?[0]
                                                  ['following']
                                              .toString() ??
                                          'loading...'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: bluetext)),
                                  Text(
                                    "Following",
                                    style: TextStyle(
                                        fontSize: 10, color: bluetext),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            (profileinnerpageshow?['media']?[0]['firstName'] ??
                                'loading...'),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: bluetext),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          (profileinnerpageshow?['media']?[0]['lastName'] ??
                              'loading...'),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: bluetext),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (profileinnerpageshow?['media']?[0]['bio'] ?? '')
                                .isEmpty
                            ? ''
                            : profileinnerpageshow['media'][0]['bio'],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: bluetext),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _toggleFollow,
                          child: Container(
                            height: 31,
                            width: 180,
                            decoration: BoxDecoration(
                                color: bluetext,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                              isFollowing ? "Unfollow" : "Follow",
                              style: TextStyle(fontSize: 10, color: white),
                            )),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          // onTap: () => Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ChatPage( userId: userId, userName: username,
                          //     conversationId: conversationId,)),
                          // ),z
                          child: Container(
                            height: 31,
                            width: 150,
                            decoration: BoxDecoration(
                                color: conainer220,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Message",
                              style: TextStyle(fontSize: 10, color: bluetext),
                            )),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(color: white, boxShadow: [
                      BoxShadow(
                        color: white1,
                        blurRadius: 1.0,
                        offset: Offset(1, 0),
                      ),
                    ]),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: bluetext,
                      unselectedLabelColor: bluetext,
                      labelStyle: TextStyle(fontSize: 10.0),
                      tabs: [
                        Tab(text: 'Photos'),
                        Tab(text: 'Videos'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: profileinnerpageshow != null &&
                                  profileinnerpageshow['media'] != null
                              ? GridView.builder(
                                  controller: _scrollController,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  itemCount:
                                      profileinnerpageshow['media'].length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index ==
                                        profileinnerpageshow['media'].length) {
                                      return _isMoreLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : SizedBox.shrink();
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        List<dynamic> imageUrls =
                                            profileinnerpageshow['media']
                                                .map((item) => item['filePath'])
                                                .toList();
                                        int selectedIndex = index;
                                        _showFullScreenImage(
                                            context,
                                            imageUrls,
                                            selectedIndex,
                                            profileinnerpageshow,
                                            index);
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Container(
                                              width: 112,
                                              height: 300,
                                              child: profileinnerpageshow[
                                                              'media'][index] !=
                                                          null &&
                                                      profileinnerpageshow[
                                                                      'media']
                                                                  [index]
                                                              ['filePath'] !=
                                                          null
                                                  ? Image.network(
                                                      profileinnerpageshow[
                                                              'media'][index]
                                                          ['filePath'],
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.network(
                                                      fallbackImageUrl),
                                            ),
                                          ),
                                          Positioned(
                                            top: 78,
                                            left: 30,
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/heart.svg",
                                                  height: 18,
                                                ),
                                                Text(
                                                  profileinnerpageshow['media']
                                                          [index]['likeCount']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 78,
                                            right: 30,
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/coment2.svg",
                                                  height: 18,
                                                ),
                                                Text(
                                                  profileinnerpageshow['media']
                                                              [index]
                                                          ['commentCount']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "No images available",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                        ),
                        vediotab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class FullScreenImageDialog extends StatefulWidget {
  final List<dynamic> imageUrls;
  final int initialIndex;
  final dynamic profileList;
  final dynamic homeList;

  FullScreenImageDialog({
    required this.imageUrls,
    required this.initialIndex,
    required this.profileList,
    this.homeList,
  });

  @override
  _FullScreenImageDialogState createState() => _FullScreenImageDialogState();
}

class _FullScreenImageDialogState extends State<FullScreenImageDialog> {
  late ScrollController scrollController;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(initialScrollOffset: widget.initialIndex * 650.0);
  }

  void _toggleLikePost(int index, String postId) {
    setState(() {
      // Find the post once and store it in a variable
      var post = widget.profileList['media']
          .firstWhere((post) => post['_id'] == postId, orElse: () => null);

      if (post != null) {
        bool isLiked = post['isLiked'] ??
            false; // Ensure isLiked is treated as a bool and not null
        post['isLiked'] = !isLiked;
        post['likeCount'] =
            (post['likeCount'] ?? 0) + (post['isLiked'] ? 1 : -1);
      }
    });

    // Call _addLike only if the post exists
    var post = widget.profileList['media']
        .firstWhere((post) => post['_id'] == postId, orElse: () => null);
    if (post != null) {
      _addLike(postId, post['isLiked']);
    }
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  void _showComments(BuildContext context, String postId) {
    showModalBottomSheet<void>(
      backgroundColor: white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0)
              .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CommentBottomSheet(id: postId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts", style: TextStyle(fontSize: 14)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onDoubleTap: () {
                    _toggleLikePost(
                        index, widget.profileList['media'][index]['_id']);
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to profile inner page
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            child: Image.network(
                                              widget.profileList['media'][index]
                                                  ['profilePic'],
                                              height: 51,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 28,
                                          left: 28,
                                          child: Image.asset(
                                              'assets/image/verificationlogo.png'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.profileList['media'][index]
                                          ['firstName'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),

                                  ],
                                ),

                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child:
                                      Icon(Icons.more_vert, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                          child: Image.network(
                            widget.imageUrls[index],
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 23, top: 10, left: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleLikePost(
                                          index,
                                          widget.profileList['media'][index]
                                              ['_id']);
                                    },
                                    child: Image.asset(
                                      widget.profileList['media'][index]
                                                  ['isLiked'] ??
                                              false
                                          ? 'assets/image/rubred.png'
                                          : 'assets/image/rubblack.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        backgroundColor: white,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          late Map<String, dynamic>? homeList;
                                          return Padding(
                                            padding: const EdgeInsets.all(20.0)
                                                .copyWith(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                            child: CommentBottomSheet(
                                                id: widget.profileList['media']
                                                    [index]['_id']),
                                          );
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/comment.svg",
                                      height: 20,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  SvgPicture.asset(
                                    "assets/svg/save.svg",
                                    height: 20,
                                  ),
                                  Expanded(child: SizedBox()),
                                  SvgPicture.asset(
                                    "assets/svg/share.svg",
                                    height: 20,
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: bluetext,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Liked by ",
                                          style: TextStyle(),
                                        ),
                                        TextSpan(
                                          text:
                                              "${widget.profileList['media'][index]['lastLikedUserName'].toString()} ",
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " and",
                                          style: TextStyle(
                                            color: bluetext,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                      "${widget.profileList['media'][index]['likeCount'] - 1}",
                                      style: TextStyle(
                                          color: bluetext,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(width: 2),
                                ],
                              ),

                              InkWell(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    backgroundColor: white,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      late Map<String, dynamic>? homeList;
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0)
                                            .copyWith(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                        child: CommentBottomSheet(
                                            id: widget.profileList['media']
                                                [index]['_id']),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: bluetext,
                                          fontSize: 12,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "View All",
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                        "${widget.profileList['media'][index]['commentCount'].toString()} Comments ",
                                        style: TextStyle(
                                          color: bluetext,
                                          fontSize: 13,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: isExpanded
                                  ? null
                                  : 40, // Adjust height when expanded
                              child: Linkify(
                                onOpen: _onOpen,
                                text: widget.profileList['media'][index]
                                    ['description'],
                                maxLines: isExpanded ? null : 2,
                                overflow: isExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                                linkStyle: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        if (widget.profileList['media'][index]['description']
                                .split('\n')
                                .length >
                            2) // Check for multiline
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded =
                                    !isExpanded; // Toggle the isExpanded state
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  isExpanded ? 'See Less' : 'See More ',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch ${link.url}';
    }
  }
}

void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls,
    int initialIndex, dynamic profileList, dynamic homeList) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.all(0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FullScreenImageDialog(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
            profileList: profileList,
          ),
        ),
      );
    },
  );
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'profileImage',
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
