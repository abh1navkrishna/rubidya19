import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:story/story.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rubidya/services/home_service.dart';
import 'package:rubidya/services/upload_image.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:rubidya/navigation/bottom_navigation.dart';

class HomeStory extends StatefulWidget {
  const HomeStory({Key? key}) : super(key: key);

  @override
  State<HomeStory> createState() => _HomeStoryState();
}

class _HomeStoryState extends State<HomeStory> {
  Trimmer? _trimmer;
  List<dynamic> _stories = [];
  bool _isLoading = true;
  bool uploading = false;
  bool isLoading = false;
  String description = '';

  @override
  void initState() {
    super.initState();
    _fetchStories();
  }

  Future<void> _fetchStories() async {
    try {
      final response = await HomeService.getStories();
      if (response['status'] == "01" && response['msg'] == "Success") {
        final List<dynamic> stories = response['story'];
        setState(() {
          _stories = stories.map((story) {
            return {
              ...story,
              'seen': false, // Initialize 'seen' property
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> uploadVideo() async {
    if (uploading) return;

    setState(() {
      uploading = true;
      isLoading = true;
    });

    try {
      // Get the video file from the gallery
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Prepare the video file for upload
        FormData formData = FormData.fromMap({
          'media': await MultipartFile.fromFile(
            pickedFile.path,
            filename: 'video.mp4',
          ),
          'description': description,
        });

        // Show the snackbar with a progress bar
        final snackBar = SnackBar(
          content: Row(
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 20),
              Text("Uploading Story...")
            ],
          ),
          duration: Duration(hours: 1), // Make it last long enough
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Upload the video using your service
        var response = await UploadService.uploadstory(formData);

        if (response['sts'] == "01") {
          print("Video uploaded successfully");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Story uploaded successfully"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Bottomnav(initialPageIndex: 0)),
                (route) => false,
          );
          print(response['msg']);
        } else {
          print(response['sts']);
          print(response['msg']);
        }
      }
    } on DioError catch (e) {
      print("Exception during video upload: $e");
      String errorMessage = "Connection error. Please try again.";
      if (e.type == DioErrorType.receiveTimeout) {
        errorMessage = "No response received. Please try again.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Exception during video upload: $e");
    } finally {
      setState(() {
        uploading = false;
        isLoading = false;
      });

      // Dismiss the progress snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Group stories by user ID
    Map<String, List<dynamic>> storiesByUser = {};
    _stories.forEach((story) {
      String userId = story['userId'];
      if (!storiesByUser.containsKey(userId)) {
        storiesByUser[userId] = [];
      }
      storiesByUser[userId]!.add(story);
    });

    // If there are no stories, display "Your Story" option
    if (storiesByUser.isEmpty) {
      return GestureDetector(
        onTap: uploadVideo,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                height: 60,
                width: 60,
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text("Your Story", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        GestureDetector(
          onTap: uploadVideo,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text("Your Story", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        ...storiesByUser.entries.map<Widget>((entry) {
          List<dynamic> userStories = entry.value;
          String username = userStories.first['username'];
          String profilePicUrl;
          if (userStories.first.containsKey('profilePic') &&
              userStories.first['profilePic'] != null) {
            profilePicUrl = userStories.first['profilePic']['filePath'];
          } else {
            // Display a Material Icon when profilePic is null
            profilePicUrl =
            "https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8=w240-h480-rw"; // Replace 'person' with the Material Icon you want to use
          }

          String truncatedUsername = username.length > 10
              ? username.substring(0, 10) + '...'
              : username;

          return GestureDetector(
            onTap: () => _playUserStories(context, userStories),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: Image.network(
                          profilePicUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            color: userStories.first['seen']
                                ? Colors.blue.shade200
                                : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(truncatedUsername, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _playUserStories(BuildContext context, List<dynamic> userStories) {
    if (userStories.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoStoryScreen(),
        ),
      );
    } else {
      userStories.forEach((story) {
        story['seen'] = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserStoriesScreen(
            userStories: userStories,
            allUserStories: _stories,
          ),
        ),
      );
    }
  }
}

class NoStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("No Stories"),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No stories",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class UserStoriesScreen extends StatefulWidget {
  final List<dynamic> userStories;
  final List<dynamic> allUserStories;

  const UserStoriesScreen(
      {Key? key, required this.userStories, required this.allUserStories})
      : super(key: key);

  @override
  _UserStoriesScreenState createState() => _UserStoriesScreenState();
}

class _UserStoriesScreenState extends State<UserStoriesScreen> {
  late List<dynamic> _currentUserStories;
  late List<Map<String, dynamic>> _allUserStoriesGrouped;
  int _currentUserIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUserStories = widget.userStories;
    _allUserStoriesGrouped = _groupStoriesByUser(widget.allUserStories);
    _currentUserIndex = _allUserStoriesGrouped.indexWhere(
          (group) => group['userId'] == _currentUserStories.first['userId'],
    );
  }

  List<Map<String, dynamic>> _groupStoriesByUser(List<dynamic> stories) {
    Map<String, List<dynamic>> storiesByUser = {};
    stories.forEach((story) {
      String userId = story['userId'];
      if (!storiesByUser.containsKey(userId)) {
        storiesByUser[userId] = [];
      }
      storiesByUser[userId]!.add(story);
    });
    return storiesByUser.entries
        .map((entry) => {'userId': entry.key, 'stories': entry.value})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StoryPageView(
          indicatorDuration: Duration(seconds: 10),
          initialPage: _currentUserIndex,
          itemBuilder: (context, pageIndex, storyIndex) {
            final story =
            _allUserStoriesGrouped[pageIndex]['stories'][storyIndex];
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black),
                ),
                Positioned.fill(
                  child: VideoPlayerWidget(videoUrl: story['filePath']),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: story['profilePic'] != null &&
                                story['profilePic']['filePath'] != null
                                ? NetworkImage(story['profilePic']['filePath'])
                                : NetworkImage(
                                "https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8=w240-h480-rw"),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        story['username'],
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          gestureItemBuilder: (context, pageIndex, storyIndex) {
            return Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
          pageLength: _allUserStoriesGrouped.length,
          storyLength: (int pageIndex) {
            return _allUserStoriesGrouped[pageIndex]['stories'].length;
          },
          onPageLimitReached: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }
}
