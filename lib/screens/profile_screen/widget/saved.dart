import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../services/home_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import 'package:visibility_detector/visibility_detector.dart';


class Saved_items extends StatefulWidget {
  const Saved_items({super.key});

  @override
  State<Saved_items> createState() => _Saved_itemsState();
}

class _Saved_itemsState extends State<Saved_items> {
  var userId;
  var profileList;
  bool isLoading = false;
  bool _isLoading = true;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initLoad();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _ProfileImage({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await ProfileService.getSaved(page: page);
    log.i('Profile Image Loading........: $response');
    setState(() {
      if (profileList == null) {
        profileList = response;
      } else {
        profileList['savedPosts'].addAll(response['savedPosts']);
      }
    });
  }

  Future<void> _addLike(String postId, bool isLiked) async {
    var reqData = {
      'postId': postId,
      'isLiked': isLiked,
    };
    var response = await HomeService.like(reqData);
    log.i('Add to Like: $response');
  }

  Future<void> _initLoad() async {
    await _ProfileImage();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _ProfileImage(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  void _toggleLike(int index, String postId) {
    setState(() {
      bool isLiked = profileList['savedPosts'][index]['isLiked'] ?? false;
      profileList['savedPosts'][index]['isLiked'] = !isLiked;
      int likeCount = profileList['savedPosts'][index]['likeCount'] ?? 0;
      profileList['savedPosts'][index]['likeCount'] =
      isLiked ? likeCount - 1 : likeCount + 1;
    });
    _addLike(
        postId,
        profileList['savedPosts']
            .firstWhere((post) => post['_id'] == postId)['isLiked']);
  }

  void _toggleSavePost(String postId) {
    setState(() {
      bool isSaved = !profileList!['savedPosts']
          .firstWhere((post) => post['_id'] == postId)['isSaved'];
      profileList!['savedPosts'].firstWhere((post) => post['_id'] == postId)['isSaved'] =
          isSaved;
    });
    _addSave(
        postId,
        profileList!['savedPosts']
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

  @override
  Widget build(BuildContext context) {
    return profileList != null && profileList['savedPosts'] != null
        ? Scaffold(
      appBar: AppBar(
        title: Text("Saved Items",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: GridView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
        ),
        itemCount: profileList['savedPosts'].length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: GestureDetector(
              onTap: () {
                // List<String> mediaUrls = profileList['savedPosts']
                //     .map<String>((item) => item['filePath'] as String?)
                //     .where((filePath) => filePath != null)
                //     .map((filePath) => filePath!) // Cast from String? to String
                //     .toList();
                //
                // print(mediaUrls);

                int selectedIndex = profileList['savedPosts']
                    .where((item) => item['filePath'] != null)
                    .toList()
                    .indexOf(profileList['savedPosts'][index]);

                _showFullScreenMedia(context, selectedIndex, profileList);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 112,
                      height: 300,
                      child: profileList['savedPosts'][index]
                      ['fileType'] ==
                          'video/mp4'
                          ? FutureBuilder(
                        future: _getVideoThumbnail(
                            profileList['savedPosts'][index]
                            ['filePath']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.hasData
                                ? Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            )
                                : Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )
                          : Image.network(
                        profileList['savedPosts'][index]
                        ['filePath'],
                        fit: BoxFit.fill,
                      ),
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
                          profileList['savedPosts'][index]['likeCount']
                              .toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.white),
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
                          profileList['savedPosts'][index]['commentCount']
                              .toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    )
        : Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(child: CircularProgressIndicator()));
  }

  Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {
    return await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
      128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
  }

  void _showFullScreenMedia(
      BuildContext context, int initialIndex, dynamic profileList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ScrollController scrollController =
        ScrollController(initialScrollOffset: initialIndex * 650.0);

        return StatefulBuilder(builder: (context,setState)
        {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              title: Text("Saved Items",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: profileList['savedPosts'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          _toggleLike(
                              index, profileList['savedPosts'][index]['_id']);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onDoubleTap: () {
                                      _toggleLike(
                                          index,
                                          profileList['savedPosts'][index]
                                          ['_id']);
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 60),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              profileList['savedPosts'][index]
                                              ['username'],
                                              overflow: TextOverflow.ellipsis,
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
                                          child: Icon(Icons.more_vert,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
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
                                                profileList['savedPosts'][index]
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
                                ],
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onDoubleTap: () {
                                  _toggleLike(index,
                                      profileList['savedPosts'][index]['_id']);
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(0))),
                                  child: profileList['savedPosts'][index]
                                  ['fileType'] ==
                                      'video/mp4'
                                      ? VideoPlayerWidget(
                                      videoUrl: profileList['savedPosts']
                                      [index]['filePath'])
                                      : Image.network(
                                    profileList['savedPosts'][index]
                                    ['filePath'],
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 23, top: 10, left: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _toggleLike(
                                                  index,
                                                  profileList['savedPosts'][index]
                                                  ['_id']);
                                            });
                                          },
                                          icon: ImageIcon(
                                            AssetImage(profileList['savedPosts']
                                            [index]['isLiked'] ??
                                                false
                                                ? 'assets/image/rubred.png'
                                                : 'assets/image/rubblack.png'),
                                            size: 30.0,
                                            color: profileList['savedPosts']
                                            [index]['isLiked']
                                                ? Colors.red
                                                : Colors.black26,
                                          ),
                                        ),

                                        // Icon(
                                        //   profileList['savedPosts'][index]
                                        //   ['isLiked'] ??
                                        //       false
                                        //       ? Icons.favorite
                                        //       : Icons.favorite_border,
                                        //   color: profileList['savedPosts'][index]
                                        //   ['isLiked'] ??
                                        //       false
                                        //       ? Colors.red
                                        //       : Colors.grey,
                                        // ),
                                        // ),
                                        SizedBox(width: 10),
                                        // SizedBox(width: 2),
                                        // SvgPicture.asset(
                                        //   "assets/svg/comment.svg",
                                        //   height: 20,
                                        // ),
                                        // SizedBox(width: 12),
                                        SizedBox(
                                          height: 50,
                                          // width: 50,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _toggleSavePost(
                                                    profileList['savedPosts'][index]
                                                    ['_id']);
                                              });

                                            },
                                            icon: profileList['savedPosts']
                                            [index]['isSaved'] ? Icon(
                                                Icons.bookmark)
                                                : Icon(
                                                Icons.bookmark_border_outlined),
                                            iconSize: 30,
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                        SvgPicture.asset(
                                          "assets/svg/share.svg",
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Liked by ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10)),
                                        Text(
                                          profileList['savedPosts'][index]
                                          ['lastLikedUserName']
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(" and ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10)),
                                        Text(
                                          profileList['savedPosts'][index]
                                          ['likeCount']
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(" others ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10)),
                                        SizedBox(width: 2),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(height: 50),
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
        );

      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        if (_isVisible) {
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (visibilityInfo) {
        setState(() {
          _isVisible = visibilityInfo.visibleFraction > 0.0;
          if (_isVisible) {
            _controller.play();
          } else {
            _controller.pause();
          }
        });
      },
      child: _controller.value.isInitialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}