import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubidya/authentication_page/terms_and_conditions.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/photo_tab.dart';
import 'package:rubidya/screens/profile_screen/tab_profile/vedio_tab.dart';
import 'package:rubidya/screens/profile_screen/widget/blokeduserlist.dart';
import 'package:rubidya/screens/profile_screen/widget/edit_profile.dart';
import 'package:rubidya/screens/profile_screen/widget/followers_list.dart';
import 'package:rubidya/screens/profile_screen/widget/following_list.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/my_wallet.dart';
import 'package:rubidya/screens/profile_screen/widget/rubidium_widget/verification_page.dart';
import 'package:rubidya/screens/profile_screen/widget/saved.dart';
import '../../commonpage/contactpage.dart';
import '../../resources/color.dart';
import '../home_screen/widgets/referral_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../authentication_page/login_page.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 0;

  late TabController _tabController;

  var userid;
  var profiledetails;
  var profilepagestatus;
  var profileimgshow;
  var postcount;

  bool isLoading = false;
  bool _isLoading = true;
  String? imageUrl;

  Future _profiledetailsapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfile();
    log.i('profile details show.. $response');
    setState(() {
      profiledetails = response;
    });
  }

  Future _postcount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.getProfileimage();
    log.i('post count data Show.. $response');
    setState(() {
      postcount = response; // This line is causing the error
    });
  }

  Future _profilestatussapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profilestatus();
    log.i('profile statsus show.. $response');
    setState(() {
      profilepagestatus = response;
    });
  }

  Future _profileimgget() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.ProfileImageget();
    log.i('profile statsus show.. $response');
    setState(() {
      profileimgshow = response;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => login()), (route) => false);
  }

  Future<void> pickImages() async {
    if (isUploading) return; // Prevent picking images during upload
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      io.File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          imageUrl = croppedFile.path;
        });
        // Call uploadImage() to upload the selected image
        uploadImage();
      }
    }
  }

  bool isUploading = false;
// Modify the uploadImage() function to upload the selected image
  Future<void> uploadImage() async {
    if (isUploading) return; // Prevent multiple uploads
    setState(() {
      isUploading = true; // Set upload state to true
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = (prefs.getString('userid') ?? "");
    try {
      if (imageUrl == null) {
        print("Please pick an image first");
        return;
      }
      FormData formData = FormData.fromMap({
        'media': await MultipartFile.fromFile(imageUrl!),
      });
      var response = await ProfileService.ProfileImageUpload(formData);
      if (response.statusCode == 201) {
        print("Image uploaded successfully");
        print(response.data);
      } else {
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print("Exception during image upload: $e");
    } finally {
      setState(() {
        isUploading =
            false; // Reset upload state regardless of success or failure
      });
    }
  }

  Future<io.File?> _cropImage(String imagePath) async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressQuality: 100,
      maxHeight: 800,
      maxWidth: 800,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
      ),
    );

    // Hide loading indicator
    setState(() {
      isLoading = false;
    });

    if (croppedFile != null) {
      setState(() {
        imageUrl = croppedFile.path;
      });

      uploadImage();
    }

    return croppedFile != null ? io.File(croppedFile.path) : null;
  }

  Future<void> _refresh() async {
    await _profiledetailsapi();
    await _profileimgget();
    setState(() {
      _isLoading = false;
    });
    uploadImage();
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _profiledetailsapi(),
        _profileimgget(),
        _profilestatussapi(),
        _postcount()
      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    _initLoad();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: DefaultTabController(
        initialIndex: _currentIndex,
        length: 2,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                ("Profile"),
                style: TextStyle(fontSize: 14),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    // Share.share("https://rubidya.com/register/$userid");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => referralpage()),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) =>  MyHomePages()),
                    // );
                  },
                  child: SvgPicture.asset(
                    "assets/svg/reffer.svg",
                  ),
                ),

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
                                )),
                            height: 400.0,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                                //   child: Align(
                                //     alignment: Alignment.topLeft,
                                //     child: Row(
                                //       children: [
                                //         SvgPicture.asset(
                                //           "assets/svg/settings.svg",
                                //           height: 14,
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           'Setting and privacy',
                                //           style: TextStyle(
                                //               fontSize: 14.0,
                                //               color: bluetext,
                                //               fontWeight: FontWeight.w200),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 25,
                                // ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TermsAndConditions()));
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/settings.svg",
                                            height: 14,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Terms and Conditions',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: bluetext,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Saved_items()));
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/save.svg",
                                            height: 14,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Saved',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: bluetext,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BlockedAccountsPage()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.block,
                                            size: 18,
                                            color: Color(0xff1E3167),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Blocked Users ',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: bluetext,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //
                                //
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                                //   child: Align(
                                //     alignment: Alignment.topLeft,
                                //     child: Row(
                                //       children: [
                                //         SvgPicture.asset(
                                //           "assets/svg/saved.svg",
                                //           height: 14,
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           'Saved',
                                //           style: TextStyle(
                                //               fontSize: 14.0,
                                //               color: bluetext,
                                //               fontWeight: FontWeight.w200),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 25,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 40),
                                //   child: Align(
                                //     alignment: Alignment.topLeft,
                                //     child: Row(
                                //       children: [
                                //         SvgPicture.asset(
                                //           "assets/svg/ads.svg",
                                //           height: 14,
                                //         ),
                                //         SizedBox(
                                //           width: 10,
                                //         ),
                                //         Text(
                                //           'Ads',
                                //           style: TextStyle(
                                //               fontSize: 14.0,
                                //               color: bluetext,
                                //               fontWeight: FontWeight.w200),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 25,
                                // ),
                                Spacer(),

                                SizedBox(
                                  height: 100,
                                ),
                                InkWell(
                                  onTap: () {
                                    logout();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Container(
                                      height: 40,
                                      width: 400,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: bluetext),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/logout.svg",
                                            height: 14,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: TextStyle(color: white),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [grad1, grad2],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Icon(Icons.more_horiz),
                    ),
                  ),
                ), //IconButton
              ],
              //<Widget>[]
              backgroundColor: white,
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickImages();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  child: profileimgshow != null &&
                                          profileimgshow['profilePic'] !=
                                              null &&
                                          profileimgshow['profilePic']
                                                  ['filePath'] !=
                                              null
                                      ? Image.network(
                                          profileimgshow['profilePic']
                                              ['filePath'],
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                                color: grad2,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                            child: Center(
                                                child: Text(
                                              "No Img",
                                              style: TextStyle(color: greybg),
                                            )),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                postcount != null &&
                                        postcount['postCount'] != null
                                    ? postcount['postCount'].toString()
                                    : '0', // Default value if postcount or postCount is null
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: bluetext,
                                ),
                              ),
                              Text("Post",
                                  style:
                                      TextStyle(fontSize: 10, color: bluetext))
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FollowersList()));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    (profiledetails?['user']?['followersCount']
                                            .toString() ??
                                        '0'),
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FollowingList()));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    (profiledetails?['user']?['followingCount']
                                            .toString() ??
                                        '0'),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: bluetext)),
                                Text(
                                  "Following",
                                  style:
                                      TextStyle(fontSize: 10, color: bluetext),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          (profiledetails?['user']?['firstName'] ??
                              'loading...'),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: bluetext),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      (profiledetails?['user']?['lastName'] ?? 'loading...'),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: bluetext),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text((profiledetails?['user']?['bio'] ?? ''),
                        style: TextStyle(
                            color: bluetext,
                            fontSize: 12,
                            fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center, // Center-align the text
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => editprofile(
                              bio: profiledetails['user']['bio'] ?? "",
                              firstname:
                                  profiledetails['user']['firstName'] ?? "",
                              lastName:
                                  profiledetails['user']['lastName'] ?? "",
                              countryCode: profiledetails['user']['countryCode']
                                      ?.toString() ??
                                  "",
                              phone:
                                  profiledetails['user']['phone']?.toString() ??
                                      "",
                              email: profiledetails['user']['email'] ?? "",
                              // dateOfBirth: profiledetails['user']
                              //         ['updatedDOB'] ??
                              //     "",
                              gender: profiledetails['user']['gender'] ?? "",
                              location:
                                  profiledetails['user']['location'] ?? "",
                              profession:
                                  profiledetails['user']['profession'] ?? "",
                              district:
                                  profiledetails['user']['district'] ?? "",
                            ),
                          ));
                        },
                        child: Container(
                          height: 31,
                          width: 110,
                          decoration: BoxDecoration(
                              color: conainer220,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Edit profile",
                            style: TextStyle(fontSize: 10, color: bluetext),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => contactpage()),
                          );
                        },
                        child: Container(
                          height: 31,
                          width: 110,
                          decoration: BoxDecoration(
                              color: conainer220,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Contact",
                            style: TextStyle(fontSize: 10, color: bluetext),
                          )),
                        ),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      // profiledetails?['user']['isVerified'] == true
                      //     ? InkWell(
                      //   onTap: () {
                      //     // Navigator.of(context).push(
                      //     //     MaterialPageRoute(
                      //     //         builder: (context) =>
                      //     //             wallet()));
                      //     Navigator.of(context).push(
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 MyWallet()));
                      //   },
                      //   child: Container(
                      //     height: 31,
                      //     width: 110,
                      //     decoration: BoxDecoration(
                      //         color: blueshade,
                      //         borderRadius: BorderRadius.all(
                      //             Radius.circular(10))),
                      //     child: Center(
                      //         child: Text(
                      //           "Wallet",
                      //           style: TextStyle(
                      //               color: white, fontSize: 12),
                      //         )),
                      //   ),
                      // )
                      //     : InkWell(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 Verification()));
                      //   },
                      //   child: Container(
                      //     height: 31,
                      //     width: 110,
                      //     decoration: BoxDecoration(
                      //         color: blueshade,
                      //         borderRadius: BorderRadius.all(
                      //             Radius.circular(10))),
                      //     child: Center(
                      //         child: Text(
                      //           "Wallet",
                      //           style: TextStyle(
                      //               color: white, fontSize: 12),
                      //         )),
                      //   ),
                      // ),

                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyWallet()));
                        },
                        child: Container(
                          height: 31,
                          width: 110,
                          decoration: BoxDecoration(
                              color: blueshade,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Wallet",
                            style: TextStyle(color: white, fontSize: 12),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          tabs: [
                            Tab(
                              child: Text(
                                'Photo',
                                style: TextStyle(
                                    fontSize:
                                        12), // Adjust the font size as needed
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Video',
                                style: TextStyle(
                                    fontSize:
                                        12), // Adjust the font size as needed
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 400,
                          child: TabBarView(
                            // physics: NeverScrollableScrollPhysics(), // Prevent swiping
                            children: [
                              PhotoTab(),
                              vediotab(),
                            ],
                          ),
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
  }
}
