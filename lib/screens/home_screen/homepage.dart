import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/resources/color.dart';
import 'package:rubidya/screens/chat_screen/MessagePage.dart';
import 'package:rubidya/screens/home_screen/widgets/comment_home.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:rubidya/screens/home_screen/widgets/likelist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rubidya/screens/home_screen/widgets/home_story.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../commonpage/notification.dart';
import '../../services/home_service.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import '../profile_screen/inner_page/profile_inner_page.dart';
import '../search_screen/searchpage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late SharedPreferences prefs;
  late IO.Socket socket;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isLoading = false;
  bool _isLoading = true;
  bool isExpanded = false;
  int _pageNumber = 1;
  String? userId;
  var profiledetails;
  String? id;
  Map<String, dynamic>? homeList;
  List<Map<String, dynamic>> suggestFollow = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initLoad();
    _profileDetailsApi();
    _initNotifications();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    socket.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      _loadMore();
    }
  }

  Future _profileDetailsApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('Profile details show: $response');
    setState(() {
      profiledetails = response;
    });
    // Initialize socket after profile details are fetched
    _initSocket();
  }

  void _initSocket() {
    String userId = "${profiledetails?['user']?['_id']?.toString()}";

    socket = IO.io('wss://rubidya.com', <String, dynamic>{
      'transports': ['websocket'],
      'query': {'userId': userId},
    });

    socket.on('connect', (_) {
      log.i('Connected to Socket.IO server');
    });

    socket.on('activityNotification', (data) {
      log.i('Received activity notification: $data');
      _showNotification(data['user'], data['message'], data['notificationType'],
          data['time']);
    });

    socket.on('disconnect', (_) {
      log.e('Disconnected from Socket.IO server');
    });
  }

  void _initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle the received notification here
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.payload != null) {
        log.i('notification payload: ${response.payload}');
        // Handle notification tap
      }
    });

    // Request permissions
    _requestIOSPermissions();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _showNotification(
      String user, String message, String notificationType, String time) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$user $notificationType',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _suggestFollowList() async {
    try {
      var response = await HomeService.usersuggetionlistfollow();
      log.i('Referral details show: $response');
      setState(() {
        suggestFollow = List<Map<String, dynamic>>.from(response['result']);
      });
    } catch (e) {
      log.e('Failed to load suggestions: $e');
    }
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      suggestFollow[index]['isFollowing'] =
          !suggestFollow[index]['isFollowing'];
    });

    var followerId = suggestFollow[index]['_id'];
    try {
      if (suggestFollow[index]['isFollowing']) {
        await HomeService.follow({'followerId': followerId});
      } else {
        await HomeService.unfollow({'followerId': followerId});
      }
    } catch (e) {
      log.e('Failed to toggle follow: $e');
    }
  }

  Future<void> _homeFeed({int page = 1}) async {
    try {
      var response = await HomeService.getFeed(page: page);
      log.i('Home feed data: $response');
      setState(() {
        if (homeList == null) {
          homeList = response;
        } else {
          homeList!['posts'].addAll(response['posts']);
        }
      });
    } catch (e) {
      log.e('Failed to load home feed: $e');
    }
  }

  Future<void> _initLoad() async {
    try {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId');
      await _homeFeed();
      await _suggestFollowList();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _homeFeed(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  String _calculateTimeDifference(String createdAt) {
    DateTime createdDateTime = DateTime.parse(createdAt);
    Duration difference = DateTime.now().difference(createdDateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  void _toggleLikePost(String postId) {
    setState(() {
      bool isLiked = !homeList!['posts']
          .firstWhere((post) => post['_id'] == postId)['isLiked'];
      homeList!['posts']
          .firstWhere((post) => post['_id'] == postId)['isLiked'] = isLiked;
      int likeCount = homeList!['posts']
          .firstWhere((post) => post['_id'] == postId)['likeCount'];
      homeList!['posts']
              .firstWhere((post) => post['_id'] == postId)['likeCount'] =
          isLiked ? likeCount + 1 : likeCount - 1;
    });
    _addLike(
        postId,
        homeList!['posts']
            .firstWhere((post) => post['_id'] == postId)['isLiked']);
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    try {
      var response = await HomeService.like({
        'postId': postId,
        'isLiked': isLiked,
      });
      log.i('Add to Like: $response');
    } catch (e) {
      log.e('Failed to like post: $e');
    }
  }

  void _toggleSavePost(String postId) {
    setState(() {
      bool isSaved = !homeList!['posts']
          .firstWhere((post) => post['_id'] == postId)['isSaved'];
      homeList!['posts']
          .firstWhere((post) => post['_id'] == postId)['isSaved'] = isSaved;
    });
    _addSave(
        postId,
        homeList!['posts']
            .firstWhere((post) => post['_id'] == postId)['isSaved']);
  }

  Future<void> _addSave(String postId, bool isSaved) async {
    try {
      var response = await HomeService.save({
        'postId': postId,
        'isSaved': isSaved,
      });
      log.i('Add to Like: $response');
    } catch (e) {
      log.e('Failed to like post: $e');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _pageNumber = 1;
      homeList = null; // Clear existing data
      _isLoading = true; // Set loading state to true during refresh
    });
    await _initLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0.1,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo/logo4.png',
                      fit: BoxFit.cover,
                      width: 150,
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => searchpage()),
                          );
                        },
                        child: Icon(
                          CupertinoIcons.search,
                          color: buttoncolor,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MessagePage()),
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/massage.svg",
                      ),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage()),
                          );
                        },
                        icon: Badge(
                            textColor: Colors.white,
                            child: Icon(
                              Icons.notifications,
                              color: buttoncolor,
                            ))),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  height: 109,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: HomeStory(), // Assuming homestory is a custom widget
                ),
              ),
              SizedBox(height: 20),
              if (_isLoading) // Show loading indicator if data is loading
                Center(child: CupertinoActivityIndicator())
              else if (homeList != null &&
                  homeList!['posts'] != null &&
                  homeList!['posts'].isNotEmpty)
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: homeList!['posts'].length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == homeList!['posts'].length) {
                      return isLoading
                          ? Center(child: CupertinoActivityIndicator())
                          : SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        ProductCard(
                          createdTime: _calculateTimeDifference(
                              homeList!['posts'][index]['createdAt']),
                          name: homeList!['posts'][index]['username'] ?? '',
                          description:
                              homeList!['posts'][index]['description'] ?? '',
                          likes: homeList!['posts'][index]['likeCount'] ?? '',
                          img: homeList!['posts'][index]['filePath'] ?? '',
                          profilepic:
                              homeList!['posts'][index]['profilePic'] ?? '',
                          likedby: homeList!['posts'][index]
                                  ['lastLikedUserName'] ??
                              '',
                          commentby: homeList!['posts'][index]
                                  ['lastCommentedUser'] ??
                              '',
                          commentcount: homeList!['posts'][index]
                                      ['commentCount']
                                  .toString() ??
                              '',
                          id: homeList!['posts'][index]['_id'] ?? '',
                          userId: homeList!['posts'][index]['userId'] ?? '',
                          filetype: homeList!['posts'][index]['fileType'] ?? '',
                          likeCount:
                              homeList!['posts'][index]['isLiked'] ?? false,
                          onLikePressed: () {
                            _toggleLikePost(homeList!['posts'][index]['_id']);
                          },
                          onDoubleTapLike: () {
                            _toggleLikePost(homeList!['posts'][index]['_id']);
                          },
                          onSavePressed: () {
                            _toggleSavePost(homeList!['posts'][index]['_id']);
                          },
                          saveCount:
                              homeList!['posts'][index]['isSaved'] ?? false,
                        ),
                      ],
                    );
                  },
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "New People",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: buttoncolor,
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestFollow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MembersListing(
                              name: suggestFollow[index]['firstName'],
                              id: suggestFollow[index]['_id'],
                              status: suggestFollow[index]['isFollowing'],
                              img: suggestFollow[index]['profilePic'] != null
                                  ? suggestFollow[index]['profilePic']
                                      ['filePath']
                                  : '',
                              onFollowToggled: () => toggleFollow(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.img,
    required this.profilepic,
    required this.name,
    required this.likes,
    required this.createdTime,
    required this.id,
    required this.userId,
    required this.likedby,
    required this.commentcount,
    required this.commentby,
    required this.description,
    required this.onLikePressed,
    required this.onDoubleTapLike,
    required this.filetype,
    required this.likeCount,
    required this.saveCount,
    required this.onSavePressed,
  }) : super(key: key);

  final String img;
  final String profilepic;
  final String name;
  final int likes;
  final String createdTime;
  final String id;
  final String userId;
  final String likedby;
  final String commentcount;
  final String commentby;
  final String description;
  final bool likeCount;
  final String filetype;
  final bool saveCount;

  final VoidCallback onLikePressed;
  final VoidCallback onDoubleTapLike;
  final VoidCallback onSavePressed;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isExpanded = false;
  late String currentImg;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.filetype == "image/jpeg") {
      currentImg = widget.img;
    } else if (widget.filetype == "video/mp4") {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.network(widget.img)
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  void reloadImage() {
    setState(() {
      currentImg = ''; // Clear the image URL to force reload
      Future.delayed(Duration.zero, () {
        setState(() {
          currentImg = widget.img;
        });
      });
    });
  }

  String generateDeepLink() {
    return 'rubidya.com/post/${widget.id}';
  }

  void sharePost(String postId) {
    final Uri deepLink = Uri.parse('rubidya.com/post/${widget.id}');
    Share.share('Check out this post: $deepLink',);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTapLike,
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onDoubleTap: () {},
                child: Row(
                  children: [
                    SizedBox(width: 60),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => profileinnerpage(
                              id: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name.length > 25
                                ? widget.name.substring(0, 25)
                                : widget.name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.createdTime,
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => profileinnerpage(
                        id: widget.userId,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: widget.profilepic.isNotEmpty
                              ? Image.network(
                                  widget.profilepic,
                                  height: 51,
                                  width: 51,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text('Failed to load image');
                                  },
                                )
                              : Image.network(
                                  'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8'),
                        ),
                      ),
                      Positioned(
                        top: 28,
                        left: 28,
                        child: Image.asset('assets/image/verificationlogo.png'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          widget.filetype == "image/jpeg"
              ? GestureDetector(
                  onTap: reloadImage,
                  child: Container(
                    key: ValueKey(currentImg),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Image.network(
                      currentImg,
                      fit: BoxFit.fill,
                      headers: {'Cache-Control': 'no-cache'},
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                          child: Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : VisibilityDetector(
                  key: Key(widget.id),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction > 0.5) {
                      if (!_videoController.value.isPlaying) {
                        _videoController.play();
                      }
                    } else {
                      if (_videoController.value.isPlaying) {
                        _videoController.pause();
                      }
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _videoController.value.isPlaying
                            ? _videoController.pause()
                            : _videoController.play();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: _videoController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio:
                                      _videoController.value.aspectRatio,
                                  child: VideoPlayer(_videoController),
                                )
                              : Center(child: CupertinoActivityIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: widget.onLikePressed,
                        icon: ImageIcon(
                          AssetImage(widget.likeCount
                              ? 'assets/image/rubred.png'
                              : 'assets/image/rubblack.png'),
                          size: 30.0,
                          color: widget.likeCount ? Colors.red : Colors.black26,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0).copyWith(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: CommentBottomSheet(id: widget.id),
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        "assets/svg/comment.svg",
                        height: 20,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: widget.filetype == "image/jpeg"
                            ? widget.onSavePressed
                            : null,
                        icon: widget.saveCount
                            ? Icon(Icons.bookmark)
                            : Icon(Icons.bookmark_border_outlined),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {
                        sharePost(widget.id);
                      },
                      icon: SvgPicture.asset(
                        "assets/svg/share.svg",
                        height: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Like_List(
                                id: widget.id,
                              )), // Replace NextPage with your desired page
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
                            TextSpan(text: "Liked by "),
                            TextSpan(
                              text: widget.likedby,
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
                        "${widget.likes - 1} Others",
                        style: TextStyle(
                            color: bluetext,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 2),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.white,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0).copyWith(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: CommentBottomSheet(id: widget.id),
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
                            TextSpan(text: "View All"),
                          ],
                        ),
                      ),
                      SizedBox(width: 2),
                      Text(
                        "${widget.commentcount} Comments",
                        style: TextStyle(
                          color: bluetext,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: isExpanded ? null : 40,
                child: Linkify(
                  onOpen: _onOpen,
                  text: widget.description,
                  maxLines: isExpanded ? null : 2,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  linkStyle: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
          widget.description.length >
                  100 // Replace 100 with your desired length
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        isExpanded ? 'See Less' : 'See More',
                        style: TextStyle(color: bluetext, fontSize: 8),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
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

class MembersListing extends StatelessWidget {
  const MembersListing({
    required this.name,
    required this.img,
    required this.status,
    required this.id,
    required this.onFollowToggled,
    Key? key,
  }) : super(key: key);

  final String name;
  final String img;
  final bool status;
  final String id;
  final VoidCallback onFollowToggled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => profileinnerpage(
                    id: id,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Container(
          height: 300,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.1,
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: img.isNotEmpty
                    ? Image.network(
                        img,
                        height: 65,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                        ),
                      ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: onFollowToggled,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: status ? bluetext : buttoncolor,
                  ),
                  child: Text(
                    status ? 'Unfollow' : 'Follow',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
