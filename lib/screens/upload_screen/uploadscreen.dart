import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubidya/screens/upload_screen/trimmer_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../commonpage/filters.dart';
import '../../services/upload_image.dart';
import '../../../resources/color.dart';
import '../../support/logger.dart';
import 'Upload_Details_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  var userid;
  String? imageUrl;
  String? videoUrl;
  String? description;
  bool showIndicator = false;
  bool uploading = false;
  bool isLoading = false;
  int selectedFilterIndex = 0;
  var mostlikeimage;

  final List<List<double>> filters = [
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX,
    COOL_MATRIX,
    LEGEND_MATRIX,
    ANJU_MATRIX,
    SUNSET_MATRIX,
    EMERALD_MATRIX,
    PASTEL_MATRIX,
    GOLDEN_MATRIX,
    OCEAN_MATRIX,
    CHERRY_BLOSSOM_MATRIX,
    MIDNIGHT_MATRIX,
    FIRE_MATRIX,
    EARTH_MATRIX,
    DESERT_MATRIX,
    AMETHYST_MATRIX,
    LAVENDER_MATRIX,
    RUBY_MATRIX,
    SAPPHIRE_MATRIX,
    TOPAZ_MATRIX,
    AQUA_MATRIX,
    FOREST_MATRIX,
    PEARL_MATRIX,
    SUNFLOWER_MATRIX,
    LEMON_MATRIX,
    ROSE_MATRIX,
    TURQUOISE_MATRIX,
    PEACH_MATRIX,
  ];

  late File image;
  late VideoPlayerController _videoPlayerController;

  var userId;
  var profileDetails;
  bool _isLoading = true;
  bool isExpanded = false;
  int _pageNumber = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _initLoad();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _MostlikeImage({int page = 1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    var response = await UploadService.getUploadMostlike(page: page);
    log.i('Most like Image Loading........: $response');
    setState(() {
      if (mostlikeimage == null) {
        mostlikeimage = response;
      } else {
        mostlikeimage['media'].addAll(response['media']);
      }
    });
  }

  Future<void> _initLoad() async {
    await _MostlikeImage();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    setState(() {
      _pageNumber++;
      isLoading = true;
    });
    await _MostlikeImage(page: _pageNumber);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl =
            pickedFile.path; // Use the original image path without cropping
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageUrl =
            pickedFile.path; // Use the original image path without cropping
      });
    }
  }

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: false,
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrimmerView(file),
        ),
      );
    }
  }

  Future<void> pickVideoFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        videoUrl = pickedFile.path;
        imageUrl = null;
        _videoPlayerController = VideoPlayerController.file(File(videoUrl!))
          ..initialize().then((_) {
            setState(() {}); // Ensure the first frame is shown
            _videoPlayerController.play();
          });
      });
    }
  }

  Future<void> _cropImage() async {
    if (imageUrl != null) {
      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageUrl!,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.blue,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedImage != null) {
        setState(() {
          imageUrl = croppedImage
              .path; // Update the imageUrl with the cropped image path
        });
      }
    }
  }

  Widget filteredImage() {
    if (imageUrl != null) {
      if (selectedFilterIndex == 0) {
        return Image.file(
          File(imageUrl!),
        );
      } else {
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(filters[selectedFilterIndex]),
          child: Image.file(
            File(imageUrl!),
          ),
        );
      }
    } else {
      return Container();
    }
  }

  Widget videoPlayerWidget() {
    if (videoUrl != null && _videoPlayerController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        actions: [
          if (imageUrl != null)
            InkWell(
              onTap: () {
                _cropImage(); // Call _cropImage function when button is pressed
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Crop",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          if (imageUrl != null)
            InkWell(
              onTap: () {
                setState(() {
                  showIndicator = !showIndicator;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          uploadedetails(imageUrl: filteredImage()),
                    ),
                  );
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Next",
                  style: TextStyle(color: buttoncolor),
                ),
              ),
            )
        ],
      ),
      body: imageUrl != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          SizedBox(height: 20),
          Container(
            height: 445,
            child: Stack(
              children: [
                if (imageUrl != null) filteredImage(),
                if (videoUrl != null) videoPlayerWidget(),
                if (showIndicator)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          if (imageUrl != null)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(filters[index]),

                          ///Replace the Image Network With Uploaded Image
                          child: Image.file(
                            File(imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 20),
        ],
      )
          : mostlikeimage != null && mostlikeimage['media'] != null
          ? GridView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: mostlikeimage['media'].length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            child: GestureDetector(
              onTap: () {
                List<dynamic> imageUrls = mostlikeimage['media']
                    .map((item) => item['filePath'])
                    .toList();
                int selectedIndex = index;
                _showFullScreenImage(
                    context, imageUrls, selectedIndex, mostlikeimage);
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 112,
                      height: 300,
                      child: Image.network(
                        mostlikeimage['media'][index]['filePath'],
                        fit: BoxFit
                            .cover, // Use BoxFit.cover to stretch and maintain aspect ratio
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
                          mostlikeimage['media'][index]['likeCount']
                              .toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.white),
                        )
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
                          mostlikeimage['media'][index]
                          ['commentCount']
                              .toString(), // This is a placeholder, should be replaced with dynamic data
                          style: TextStyle(
                              fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ],
              ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 100,
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt_outlined),
                                title: Text('Photo'),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickImages();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            backgroundColor: bluetext,
            child: Icon(Icons.camera, color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 220,
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              ListTile(
                                leading: Icon(Icons.videocam),
                                title: Text('Video'),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickVideo();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.videocam_outlined),
                                title: Text('Record Video'),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickVideoFromCamera();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            backgroundColor: bluetext,
            child: Icon(Icons.file_upload_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

void _showFullScreenImage(BuildContext context, List<dynamic> imageUrls,
    int initialIndex, dynamic mostlikeimage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Using a ScrollController to manage the scroll position
      ScrollController scrollController = ScrollController(
          initialScrollOffset: initialIndex *
              650.0); // Assuming image height is 600. Adjust as needed.

      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Posts",
            style: TextStyle(fontSize: 14),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    // Handle double tap here
                    child: Container(
                      // height: 610,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    SizedBox(width: 60),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mostlikeimage['media'][index]
                                          ['firstName'],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        // Text(
                                        //   profilelist['media'][index]['userId']['lastName'],
                                        //   style: TextStyle(fontSize: 11, color: Colors.grey),
                                        // ),
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => profileinnerpage(
                                  //       id: widget.userId,
                                  //     ),
                                  //   ),
                                  // );
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
                                          color: Colors
                                              .transparent, // Set background color to transparent
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Image.network(
                                            mostlikeimage['media'][index]
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
                          Container(
                            key: ValueKey(
                              imageUrls[index],
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.fill,
                              headers: {'Cache-Control': 'no-cache'},
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Center(
                                  child: Text(
                                    'Failed to load image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 23, top: 10, left: 15),
                            child: Row(
                              children: [
                                // FavoriteButton(
                                //   iconSize: 40,
                                //   isFavorite: widget.likeCount,
                                //   iconDisabledColor: Colors.black26,
                                //   valueChanged: (_) {
                                //     widget.onLikePressed(); // Call the callback function when like button is pressed
                                //   },
                                // ),
                                SizedBox(width: 10),
                                Text("Likes",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 10)),
                                SizedBox(width: 2),
                                Text(
                                  mostlikeimage['media'][index]['likeCount']
                                      .toString(), // Convert int to String
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Expanded(child: SizedBox()),
                                SvgPicture.asset(
                                  "assets/svg/comment.svg",
                                  height: 20,
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/svg/share.svg",
                                  height: 20,
                                ),
                                SizedBox(width: 20),
                                SvgPicture.asset(
                                  "assets/svg/save.svg",
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: Container(
                          //     height: isExpanded ? null : 40, // Adjust height when expanded
                          //     child: Text(
                          //       widget.description,
                          //       maxLines: isExpanded ? null : 2,
                          //       style: TextStyle(fontSize: 11),
                          //     ),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   onTap: () {
                          //     setState(() {
                          //       isExpanded = !isExpanded;
                          //     });
                          //   },
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(horizontal: 10),
                          //     child: Align(
                          //       alignment: Alignment.bottomRight,
                          //       child: Text(
                          //         isExpanded ? 'See Less' : 'See More',
                          //         style: TextStyle(color: bluetext,fontSize: 8),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 50,
                          )
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
    },
  );
}