import 'package:flutter/material.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

class editprofile extends StatefulWidget {
  editprofile({
    super.key,
    required this.bio,
    required this.firstname,
    required this.lastName,
    required this.countryCode,
    required this.phone,
    required this.email,
    // required this.dateOfBirth,
    required this.gender,
    required this.location,
    required this.profession,
    required this.district,
  });

  final String bio;
  final String firstname;
  final String lastName;
  final String countryCode;
  final String phone;
  final String email;
  // final String dateOfBirth;
  final String gender;
  final String location;
  final String profession;
  final String district;

  @override
  State<editprofile> createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  late TextEditingController bioController;
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController professionController;
  late TextEditingController genderController;
  // late TextEditingController dateOfBirthController;
  late TextEditingController districtController;
  late TextEditingController locationController;
  late TextEditingController phoneController;

  Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');

  late String bio;
  late String firstname;
  late String lastName;
  late String countryCode;
  late String phone;
  late String email;
  // late String dateOfBirth;
  late String gender;
  late String location;
  late String profession;
  late String district;

  var userid;
  String? imageUrl;
  bool _isLoading = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // editWorkReport();
    bioController = TextEditingController(text: widget.bio);
    firstnameController = TextEditingController(text: widget.firstname);
    lastnameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    professionController = TextEditingController(text: widget.profession);
    genderController = TextEditingController(text: widget.gender);
    // dateOfBirthController = TextEditingController(text: widget.dateOfBirth);
    districtController = TextEditingController(text: widget.district);
    locationController = TextEditingController(text: widget.location);
    phoneController = TextEditingController(text: widget.phone);
  }

  Future<void> editWorkReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    print(userid);
    var reqData = {
      'firstName': firstnameController.text,
      'lastName': lastnameController.text,
      'countryCode': _selectedCountry.phoneCode,
      'email': emailController.text,
      // 'bio': bioController.text,
      'bio': bioController.text.isEmpty ? " " : bioController.text,
      'profession': professionController.text,
      'gender': genderController.text,
      // 'dateOfBirth': dateOfBirthController.text,
      'district': districtController.text,
      'location': locationController.text,
      'phone': phoneController.text,
    };

    print(bioController.text);
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
      var response = await ProfileService.ProfileEditing(reqData);
      log.i('Profile Editing Page. $response');

      // Pop the current page from the stack
      Navigator.pop(context);
      uploadImage();
      // Push the current page again to reload it
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => editprofile(
                  // Pass the same parameters to recreate the page
                  bio: bioController.text,
                  firstname: firstnameController.text,
                  lastName: lastnameController.text,
                  countryCode: widget.countryCode,
                  phone: phoneController.text,
                  email: emailController.text,
                  // dateOfBirth: dateOfBirthController.text,
                  gender: genderController.text,
                  location: locationController.text,
                  profession: professionController.text,
                  district: districtController.text,
                )),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Bottomnav(
                  initialPageIndex: 4,
                )),
      );
    } catch (error) {
      print('Error editing work report: $error');
    } finally {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> uploadImage() async {
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Bottomnav()),
        // );
      } else {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Bottomnav()),
        // );
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print("Exception during image upload: $e");
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          imageUrl = croppedFile.path;
        });
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    final imageCropper = ImageCropper();
    File? croppedFile = await imageCropper.cropImage(
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
    return croppedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(fontSize: 14)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: CircleAvatar(
            //     radius: 40.0,
            //     backgroundColor: Colors.white,
            //     child: CircleAvatar(
            //       radius: 60.0,
            //       // Check if imageUrl is not null before using it
            //       child: Align(
            //         alignment: Alignment.bottomRight,
            //         child: InkWell(
            //           onTap: (){
            //             pickImages();
            //           },
            //           child: CircleAvatar(
            //               radius: 15.0,
            //               backgroundColor: Colors.white,
            //               child: Icon(CupertinoIcons.camera_circle_fill)
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            InkWell(
              onTap: () {
                pickImages();
              },
              child: Container(
                height:
                    100, // Adjust height to fit inside the circular container
                width: 100,
                decoration: BoxDecoration(
                  color: profilebg,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: imageUrl != null
                          ? ClipOval(
                              child: Image.file(
                                File(imageUrl!),
                                fit: BoxFit
                                    .cover, // This will ensure the image fills the circular area
                                height:
                                    100, // Adjust height to fit inside the circular container
                                width:
                                    100, // Adjust width to fit inside the circular container
                              ),
                            )
                          : Container(), // This will render an empty container if imageUrl is null
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
                          pickImages();
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  // prefixIcon: Icon(
                  //   Icons.person,
                  //   size: 15,
                  //   color: bordercolor,
                  // ),
                ),
                onChanged: (text) {
                  setState(() {
                    firstname = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: lastnameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                  // prefixIcon: Icon(
                  //   Icons.person,
                  //   size: 15,
                  //   color: bordercolor,
                  // ),
                ),
                onChanged: (text) {
                  setState(() {
                    lastName = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: bordercolor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CountryPickerDropdown(
                        initialValue: _selectedCountry == null
                            ? 'IN'
                            : _selectedCountry.isoCode,
                        itemBuilder: (Country country) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CountryPickerUtils.getDefaultFlagImage(country),
                              SizedBox(width: 5),
                              Text(
                                "${country.phoneCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${country.isoCode}",
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          );
                        },
                        onValuePicked: (Country country) {
                          setState(() {
                            _selectedCountry = country;
                            print(_selectedCountry);
                          });
                        },
                      ),
                    ),
                  ),

                  // SizedBox(width: 5,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: 169,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: textblack, fontSize: 12),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: bordercolor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: bordercolor),
                          ),

                          // prefixIcon: Icon(
                          //   Icons.phone_android,
                          //   size: 15,// You can replace 'Icons.email' with the icon you want
                          //   color: bordercolor,
                          // ),
                        ),
                        onChanged: (text) {
                          setState(() {
                            phone = text;
                          });
                        },
                        style: TextStyle(color: textblack, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    email = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                  hintText: 'Bio',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    bio = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: professionController,
                decoration: InputDecoration(
                  hintText: 'Profession',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    profession = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: genderController,
                decoration: InputDecoration(
                  hintText: 'Gender',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    gender = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: TextField(
            //     controller: dateOfBirthController,
            //     decoration: InputDecoration(
            //       hintText: 'Date of Birth',
            //       hintStyle: TextStyle(color: textblack, fontSize: 12),
            //       contentPadding:
            //       EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         borderSide: BorderSide(color: bordercolor, width: 1),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //         borderSide: BorderSide(color: bordercolor),
            //       ),
            //
            //     ),
            //     onChanged: (text) {
            //       setState(() {
            //         dateOfBirth = text;
            //       });
            //     },
            //     style: TextStyle(color: textblack, fontSize: 14),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: districtController,
                decoration: InputDecoration(
                  hintText: 'District',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    district = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: 'Location',
                  hintStyle: TextStyle(color: textblack, fontSize: 12),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: bordercolor),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    location = text;
                  });
                },
                style: TextStyle(color: textblack, fontSize: 14),
              ),
            ),

            SizedBox(
              height: 40,
            ),

            InkWell(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                editWorkReport().then((_) {
                  // After editWorkReport() completes, uploadImage() will start
                  uploadImage().then((_) {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Container(
                      height: 40,
                      width: 400,
                      decoration: BoxDecoration(
                        color: bluetext,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(fontSize: 12, color: white),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isLoading,
                      child: Container(
                        height: 40,
                        width: 400,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
