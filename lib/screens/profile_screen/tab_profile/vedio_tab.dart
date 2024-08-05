import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/dio_helper.dart';
import '../../../support/logger.dart';
import 'fullScreenimagepage.dart';

class vediotab extends StatefulWidget {
  String? innerUser;

  vediotab({super.key, this.innerUser});

  @override
  State<vediotab> createState() => _vediotabState();
}

class _vediotabState extends State<vediotab> {
  var userId;
  var profileList;
  var homeList;
  bool isLoading = false;
  bool _isLoading = true;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initLoad();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  static Future<Map<String, dynamic>> getMyVideos(
      {int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
          'https://rubidya.com/api/posts/get-all-videos?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  static Future<Map<String, dynamic>> getUserVideos(String user,
      {int page = 1, int limit = 12}) async {
    try {
      var dio = await DioHelper.getInstance();
      var response = await dio.get(
          'https://rubidya.com/api/users/get-video-details/$user?page=$page&limit=$limit');
      return response.data;
    } catch (e) {
      // Handle error appropriately, e.g., log the error or throw it further
      throw e;
    }
  }

  Future<void> _ProfileImage({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response;
    if (widget.innerUser != null) {
      response = await getUserVideos(widget.innerUser!);
    } else {
      response = await getMyVideos(page: page);
    }

    print(widget.innerUser);

    log.i('Profile Image Loading........: $response');
    setState(() {
      if (profileList == null) {
        profileList = response;
      } else {
        profileList['media'].addAll(response['media']);
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

  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 100, // adjust as needed
      quality: 25, // adjust as needed
    );
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    return profileList != null && profileList['media'] != null
        ? Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GridView.builder(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7,
              ),
              itemCount: profileList['media'].length,
              itemBuilder: (BuildContext context, int index) {
                String videoUrl = profileList['media'][index]['filePath'];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideoPage(
                            videoUrl: profileList['media'][index]['filePath'],
                            likeCount: profileList['media'][index]['likeCount'],
                            description: profileList['media'][index]
                                ['description'],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FutureBuilder<Uint8List?>(
                            future: _generateThumbnail(videoUrl),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.fill,
                                  width: 112,
                                  height: 300,
                                );
                              } else {
                                return Container(
                                  width: 112,
                                  height: 300,
                                  color: Colors.grey, // Placeholder color
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 125,
                          left: 30,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/heart.svg",
                                height: 18,
                              ),
                              Text(
                                profileList['media'][index]['likeCount']
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 125,
                          right: 30,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/coment2.svg",
                                height: 18,
                              ),
                              Text(
                                profileList['media'][index]['commentCount']
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
        : Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Text("No videos available",
                    style: TextStyle(color: Colors.black)),
          );
  }
}
