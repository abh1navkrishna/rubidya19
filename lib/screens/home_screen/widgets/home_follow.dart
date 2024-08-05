// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../networking/constant.dart';
// import '../../../resources/color.dart';
// import '../../../services/home_service.dart';
// import '../../../support/logger.dart';
// import 'package:favorite_button/favorite_button.dart';
//
// import '../../profile_screen/inner_page/profile_inner_page.dart';
//
// class HomeFollow extends StatefulWidget {
//   const HomeFollow({Key? key}) : super(key: key);
//
//   @override
//   State<HomeFollow> createState() => _HomeFollowState();
// }
//
// class _HomeFollowState extends State<HomeFollow> {
//   bool isLoading = false;
//   late SharedPreferences prefs;
//
//   late List<Map<String, dynamic>> suggestFollow = [];
//
//   @override
//   void initState() {
//     _initLoad();
//     super.initState();
//   }
//
//   Future<void> _initLoad() async {
//     prefs = await SharedPreferences.getInstance();
//     await _suggestFollowList();
//   }
//
//   Future<void> _suggestFollowList() async {
//     var response = await HomeService.usersuggetionlistfollow();
//     log.i('refferal details show.. $response');
//     setState(() {
//       suggestFollow = List<Map<String, dynamic>>.from(response['result']);
//     });
//   }
//
//   Future<void> toggleFollow(int index) async {
//     setState(() {
//       suggestFollow[index]['isFollowing'] = !suggestFollow[index]['isFollowing'];
//     });
//
//     var followerId = suggestFollow[index]['_id'];
//     if (suggestFollow[index]['isFollowing']) {
//       await follow(followerId);
//     } else {
//       await unfollow(followerId);
//     }
//   }
//
//   Future<void> follow(String followerId) async {
//     var reqData = {
//       'followerId': followerId};
//     var response = await HomeService.follow(reqData);
//     log.i('add to follow. $response');
//   }
//
//   Future<void> unfollow(String followerId) async {
//     var reqData = {'followerId': followerId};
//     var response = await HomeService.unfollow(reqData);
//     log.i('removed from follow. $response');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: suggestFollow.length,
//       itemBuilder: (BuildContext context, int index) {
//         return MembersListing(
//           name: suggestFollow[index]['firstName'],
//           id: suggestFollow[index]['_id'],
//           status: suggestFollow[index]['isFollowing'],
//           img: suggestFollow[index]['profilePic'] != null
//               ? suggestFollow[index]['profilePic']['filePath']
//               : '',
//           onFollowToggled: () => toggleFollow(index),
//         );
//       },
//     );
//   }
// }
//
// class MembersListing extends StatelessWidget {
//   const MembersListing({
//     required this.name,
//     required this.img,
//     required this.status,
//     required this.id,
//     required this.onFollowToggled,
//     Key? key,
//   }) : super(key: key);
//
//   final String name;
//   final String img;
//   final bool status;
//   final String id;
//   final VoidCallback onFollowToggled;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) =>  profileinnerpage(
//             id: id,
//           )),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//         child: Container(
//           height: 300,
//           width: 100,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 0.1,
//                 blurRadius: 5,
//                 offset: Offset(0, 1),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               SizedBox(height: 10,),
//               ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(100)),
//                 child: img.isNotEmpty
//                     ? Image.network(
//                   img,
//                   height: 65,
//                   fit: BoxFit.cover,
//                 )
//                     : Container(
//                   width: 60,
//                   height: 60,
//                   child: Image.network(
//                     'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
//                   ),
//                 ),
//               ),
//               SizedBox(height: 5,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 child: Text(
//                   name,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontSize: 11),
//                 ),
//               ),
//               SizedBox(height: 10,),
//
//               GestureDetector(
//                 onTap: onFollowToggled,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: status ? bluetext : buttoncolor,
//                   ),
//                   child: Text(
//                     status ? 'Unfollow' : 'Follow',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
