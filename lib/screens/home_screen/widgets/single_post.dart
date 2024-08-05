import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rubidya/screens/home_screen/widgets/comment_home.dart';
import 'package:rubidya/services/home_service.dart';
import 'dart:io';
import 'package:flutter_linkify/flutter_linkify.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';




class SinglePostScreen extends StatefulWidget {
  final String postId;

  SinglePostScreen({required this.postId});

  @override
  _SinglePostScreenState createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  Map<String, dynamic>? postDetails;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  void _fetchPostDetails() async {
    try {
      postDetails = await HomeService.singlepost(widget.postId);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  void _toggleLikePost(String postId) {
    // Implement like toggle logic
  }

  void _deletePost(String postId) {
    // Implement delete post logic
  }

  void _onOpen(LinkableElement link) {
    // Implement on link open logic
  }

  @override
  Widget build(BuildContext context) {
    if (postDetails == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: GestureDetector(
        onDoubleTap: () {
          _toggleLikePost(postDetails!['_id']);
        },
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile inner page
                      },
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
                              child: CachedNetworkImage(
                                imageUrl: postDetails!['profilePic'],
                                height: 51,
                                fit: BoxFit.cover,
                                httpHeaders: {'Cache-Control': 'no-cache'},
                                progressIndicatorBuilder: (context, url, downloadProgress) => Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) => Center(child: Text('Failed to load image', style: TextStyle(color: Colors.red))),
                              ),
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
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postDetails!['firstName'],
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: Icon(Icons.more_vert, color: Colors.grey),
                          onPressed: () {
                            // Show the bottom sheet when the icon button is pressed
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        topLeft: Radius.circular(40),
                                      )),
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 400), // Set the maximum width here
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.white,
                                                      surfaceTintColor: Colors.white,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      title: Text('Delete Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                                      content: Text('Are you sure you want to delete this Post?'),
                                                      actions: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 20, right: 10),
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), border: Border.all(color: Colors.redAccent, width: 1.5)),
                                                                  child: Center(child: Text('Cancel', style: TextStyle(fontSize: 15, color: Colors.redAccent, fontWeight: FontWeight.w500))),
                                                                ),
                                                              ),
                                                              // SizedBox(width: 20,),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  // Show circular progress indicator
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return Center(
                                                                        child: CircularProgressIndicator(),
                                                                      );
                                                                    },
                                                                  );

                                                                  // Wait for 3 seconds before navigating
                                                                  Future.delayed(Duration(seconds: 5), () {
                                                                    _deletePost(postDetails!['_id']);
                                                                    Navigator.of(context).pushAndRemoveUntil(
                                                                      MaterialPageRoute(builder: (context) =>Bottomnav(initialPageIndex: 4)),
                                                                          (route) => false,
                                                                    );
                                                                  });
                                                                },
                                                                child: Container(
                                                                  height: 40,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                  child: Center(child: Text('Delete', style: TextStyle(fontSize: 15, color: Colors.white))),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(20).copyWith(top: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.delete, color: Colors.redAccent, size: 20, semanticLabel: 'Text to announce in accessibility modes'),
                                                        SizedBox(width: 15),
                                                        Text('Delete Post', style: TextStyle(fontSize: 20, color: bluetext, fontWeight: FontWeight.w300)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
                child: Image.network(
                  postDetails!['imageUrl'],
                  fit: BoxFit.scaleDown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 23, top: 10, left: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _toggleLikePost(postDetails!['_id']);
                          },
                          child: Image.asset(
                            postDetails!['isLiked']?? false
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
                                return Padding(
                                  padding: const EdgeInsets.all(20.0).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: CommentBottomSheet(id: postDetails!['_id']),
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: bluetext, fontSize: 12),
                            children: [
                              TextSpan(
                                text: "Liked by ",
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: "${postDetails!['likeCount'].toString()}",
                                style: TextStyle(color: bluetext, fontWeight: FontWeight.w800),
                              ),
                              TextSpan(
                                text: " and",
                                style: TextStyle(color: bluetext, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2),
                        Text(
                            "${postDetails!['lastLikedUserName'].toString()} Others ",
                            style: TextStyle(color: bluetext, fontSize: 13, fontWeight: FontWeight.w700)),
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
                            return Padding(
                              padding: const EdgeInsets.all(20.0).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: CommentBottomSheet(id: postDetails!['_id']),
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: bluetext, fontSize: 12),
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
                              "${postDetails!['commentCount'].toString()} Comments ",
                              style: TextStyle(color: bluetext, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: isExpanded
                        ? null
                        : 40, // Adjust height when expanded
                    child: Linkify(
                      onOpen: _onOpen,
                      text: postDetails!['description'],
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      linkStyle: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              if (postDetails!['description'].split('\n').length > 2) // Check for multiline
              // Check for multiline
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded; // Toggle the isExpanded state
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}