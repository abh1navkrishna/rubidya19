import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../commonpage/filters.dart';
import '../../services/upload_image.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../resources/color.dart';
import 'Upload_Details_page.dart';
// Import the uploadedetails screen

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  var userid;
  String? imageUrl;
  String? description;
  bool showIndicator = false;
  bool uploading = false; // Flag to track if upload is in progress

  // Define selectedFilterIndex variable
  int selectedFilterIndex = 0; // Initialize with 0 or any default value

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

    // XABI_MATRIX
  ];



  late File image;


  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Use the original image path without cropping
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path; // Use the original image path without cropping
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
          imageUrl = croppedImage.path; // Update the imageUrl with the cropped image path
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

  String filteredImageUrl() {
    if (imageUrl != null) {
      if (selectedFilterIndex == 0) {
        return imageUrl!;
      } else {
        return imageUrl!;
      }
    } else {
      return '';
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
              onTap: (){
                setState(() {
                  showIndicator = !showIndicator;
                  // uploadImage(); // Call uploadImage function

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => uploadedetails(imageUrl: filteredImage()),
                    ),
                  );


                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Next",style: TextStyle(color: buttoncolor),),
              ),
            )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),

          SizedBox(height: 20),
          Center(
            child: Container(
              height: 445,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0), // Adjust the radius as per your preference
                      child: filteredImage(),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
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
                        print(filteredImage);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5), // Adjust the radius as per your preference
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(filters[index]),
                          child: Image.network(
                            'https://cdn.britannica.com/45/5645-050-B9EC0205/head-treasure-flower-disk-flowers-inflorescence-ray.jpg',
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              pickImageFromCamera();
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 50),
                                Text("Camera"),
                              ],
                            ),
                          ),
                          SizedBox(width: 50),
                          InkWell(
                            onTap: () {
                              pickImages();
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Icon(Icons.image, size: 50),
                                Text("Gallery"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: bluetext,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}