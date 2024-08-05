import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../profile_screen/inner_page/profile_inner_page.dart';

class CommentBottomSheet extends StatefulWidget {
  final String id;

  const CommentBottomSheet({super.key, required this.id});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}


class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool isExpanded = false;
  var userid;
  List<dynamic> commentList = [];
  String? comment;
  String? replaycomment;
  bool _isLoading = false;
  bool showReplies = false;
  List<bool> showRepliesList = [];
  var likeCount;

  bool isLiked = true;

  int _currentPage = 1;
  bool _isLastPage = false;
  bool _isFetchingMore = false;

  bool _isSendButtonEnabled = true;

  TextEditingController _commentController = TextEditingController();

  Future<void> _likecomment(String commentId) async {
    var reqData = {
      'commentId': commentId,
    };

    try {
      var response = await HomeService.postlikecomment(reqData);
      log.i('Comment Like: $response');


      setState(() {
        for (var comment in commentList) {
          if (comment['commentId'] == commentId) {
            if (comment['isLiked']) {
              comment['isLiked'] = false;
              comment['likesOfComment'] = (comment['likesOfComment'] ?? 1) - 1;
            } else {
              comment['isLiked'] = true;
              comment['likesOfComment'] = (comment['likesOfComment'] ?? 0) + 1;
            }
            break;
          }
        }
      });
    } catch (e) {
      log.e('Error liking comment: $e');
    }
  }

  Future<void> _addComment() async {
    if (comment?.isNotEmpty ?? false) {
      setState(() {
        _isLoading = true;
        _isSendButtonEnabled = false;
      });
      var reqData = {
        'mediaId': widget.id,
        'comment': comment,
      };
      try {
        var response = await HomeService.postcomment(reqData);
        log.i('Add Comment: $response');
        await _fetchComments(reset: true);
        setState(() {
          comment = '';
          _commentController.clear();
          _isLoading = false;
          _isSendButtonEnabled = true;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _isSendButtonEnabled = true;
        });
      }
    }
  }

  Future<void> _addreplayComment(String commentId) async {
    if (replaycomment?.isNotEmpty ?? false) {
      setState(() {
        _isLoading = true;
      });
      var reqData = {
        'commentId': commentId,
        'comment': replaycomment,
      };
      try {
        var response = await HomeService.postreplaycomment(reqData);
        log.i('Add Reply Comment: $response');
        await _fetchComments(reset: true);
        setState(() {
          replaycomment = '';
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      var response = await HomeService.deletemycomment(commentId);
      log.i('Delete Comment: $response');
      Fluttertoast.showToast(
        msg: "Comment deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 14.0,
      );
      await _fetchComments(reset: true);
    } catch (e) {
      log.e('Error deleting comment: $e');
      Fluttertoast.showToast(
        msg: "Failed to delete comment",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> _fetchComments({bool reset = false}) async {
    if (_isFetchingMore) return;
    if (reset) {
      setState(() {
        _currentPage = 1;
        _isLastPage = false;
        commentList.clear();
      });
    }
    if (_isLastPage) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await HomeService.comment(widget.id, page: _currentPage);

      if (response['status'] == '01' && response['msg'] == 'Success') {
        setState(() {
          List<dynamic> newComments = response['results'] ?? [];
          commentList.addAll(newComments);


          likeCount = 0;
          for (var comment in newComments) {
            likeCount += comment['likesOfComment'] ?? 0;
          }

          for (var comment in newComments) {
            isLiked = comment['isLiked'] ?? false;
            comment['isLiked'] = isLiked;
            comment['isLiked'] = isLiked;
          }

          showRepliesList = List<bool>.filled(commentList.length, false);
          _isLastPage = newComments.length < 10;
          _currentPage++;
        });
      } else {
        print('Failed to fetch comments: ${response['msg']}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    } finally {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 3,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: commentList.isNotEmpty
                ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                    !_isFetchingMore) {
                  _fetchComments();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: commentList.length + 1,
                itemBuilder: (context, index) {
                  if (index == commentList.length) {
                    return _isFetchingMore
                        ? Center(child: CupertinoActivityIndicator())
                        : SizedBox.shrink();
                  }
                  var commentItem = commentList[index];
                  bool isMyComment = commentItem['isMyComment'] ?? false;
                  String profilePicUrl = (commentItem['profilePic'] ?? '').toString();
                  likeCount = commentItem['likesOfComment'] ?? 0;
                  isLiked = commentItem['isLiked'] ?? false;

                  bool isValidUrl = Uri.tryParse(profilePicUrl)?.isAbsolute ?? false;
                  List<dynamic> replies = commentItem['replyComment'] ?? [];

                  return Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isValidUrl)
                            GestureDetector(
                              onLongPress: (){
                                if (isMyComment) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Comment?'),
                                        content: Text('Delete this comment?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              _deleteComment(commentItem['commentId']);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => profileinnerpage(
                                            id: commentItem['userId'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16.0),
                                      child: CircleAvatar(
                                        backgroundImage: isValidUrl && commentItem['profilePic'] != null
                                            ? NetworkImage(commentItem['profilePic'])
                                            : null,
                                        child: !isValidUrl || commentItem['profilePic'] == null
                                            ? Image.network("https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8")
                                            : null,
                                        radius: 20,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      // onLongPress: () {
                                      //   if (isMyComment) {
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) {
                                      //         return AlertDialog(
                                      //           title: Text('Delete Comment?'),
                                      //           content: Text('Delete this comment?'),
                                      //           actions: <Widget>[
                                      //             TextButton(
                                      //               onPressed: () {
                                      //                 _deleteComment(commentItem['commentId']);
                                      //                 Navigator.pop(context);
                                      //               },
                                      //               child: Text('Delete'),
                                      //             ),
                                      //           ],
                                      //         );
                                      //       },
                                      //     );
                                      //   }
                                      // },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(commentItem['firstName'] ?? '',
                                             // style: Theme.of(context).textTheme.subtitle1
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5.0),
                                            child: Text(commentItem['comment'] ?? ''),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isValidUrl)
                                    GestureDetector(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                await _likecomment(commentItem['commentId']);
                                              },
                                              icon: Icon(
                                                isLiked ? Icons.favorite : Icons.favorite_border,
                                                color: isLiked ? Colors.red : Colors.grey,
                                                size: 20,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Text(
                                                likeCount.toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  // if (isMyComment)
                                  //   GestureDetector(
                                  //     onTap: () {
                                  //       showDialog(
                                  //         context: context,
                                  //         builder: (BuildContext context) {
                                  //           return AlertDialog(
                                  //             title: Text('Delete Comment?'),
                                  //             content: Text('Delete this comment?'),
                                  //             actions: <Widget>[
                                  //               TextButton(
                                  //                 onPressed: () {
                                  //                   _deleteComment(commentItem['commentId']);
                                  //                   Navigator.pop(context);
                                  //                 },
                                  //                 child: Text('Delete'),
                                  //               ),
                                  //             ],
                                  //           );
                                  //         },
                                  //       );
                                  //     },
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.symmetric(vertical: 13.0),
                                  //       child: Icon(Icons.delete, size: 20, color: Colors.red),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          SizedBox(height: 4),
                          if (isValidUrl)
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        width: 300,
                                        height: 50,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _isLoading
                                                ? Center(child: CupertinoActivityIndicator())
                                                : SizedBox(),
                                            !_isLoading
                                                ? TextField(
                                              decoration: InputDecoration(
                                                hintText: 'Write your reply here...',
                                                hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.send, color: buttoncolor),
                                                  onPressed: () async {
                                                    if (replaycomment?.isNotEmpty ?? false) {
                                                      await _addreplayComment(commentItem['commentId']);
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              ),
                                              onChanged: (text) {
                                                setState(() {
                                                  replaycomment = text;
                                                });
                                              },
                                            )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Reply",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showRepliesList[index] = !showRepliesList[index];
                              });
                            },
                            child: Column(
                              children: [
                                if (replies.isNotEmpty)
                                  Text(
                                    showRepliesList[index]
                                        ? "-------Hide replies"
                                        : "-------View Replies (${replies.length})",
                                    style: TextStyle(fontSize: 10),
                                  ),
                              ],
                            ),
                          ),
                          if (showRepliesList[index])
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: replies.length,
                              itemBuilder: (BuildContext context, int replyIndex) {
                                var replyItem = replies[replyIndex];
                                String replyProfilePicUrl = replyItem['userId']['profilePic']['filePath'] ?? '';
                                bool isReplyValidUrl = Uri.tryParse(replyProfilePicUrl)?.isAbsolute ?? false;
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    child: isReplyValidUrl
                                        ? Image.network(
                                      replyProfilePicUrl,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    )
                                        : Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    replyItem['userId']['firstName'],
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    replyItem['comment'] ?? '',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                        ],
                      ));
                },
              ),
            )
                : Center(child: Text('No comments yet')),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: _isSendButtonEnabled ? buttoncolor : Colors.grey),
                        onPressed: _isSendButtonEnabled
                            ? () async {
                          if (comment?.isNotEmpty ?? false) {
                            await _addComment();
                          }
                        }
                            : null,
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        comment = text;
                      });
                    },
                    enabled: _isSendButtonEnabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}