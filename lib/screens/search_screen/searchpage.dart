import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../networking/constant.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:favorite_button/favorite_button.dart';

import '../../services/search_service.dart';
import '../profile_screen/inner_page/profile_inner_page.dart';

class searchpage extends StatefulWidget {
  const searchpage({Key? key}) : super(key: key);

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  bool isLoading = false;
  late SharedPreferences prefs;
  late List<Map<String, dynamic>> searchlist = [];
  late TextEditingController _searchController;
  late List<Map<String, dynamic>> originalSearchList = [];


  @override
  void initState() {
    _initLoad();
    _searchController = TextEditingController(); // Initialize the TextEditingController
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the TextEditingController
    super.dispose();
  }

  Future<void> _initLoad() async {
    prefs = await SharedPreferences.getInstance();
    await _searchFollowList();
  }

  Future<void> _searchFollowList() async {
    try {
      var response = await SearchService.searchpage();
      if (mounted) {
        setState(() {
          originalSearchList = List<Map<String, dynamic>>.from(response['result']);
          searchlist = List<Map<String, dynamic>>.from(originalSearchList);
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching search data: $e');
    }
  }

  Future<void> toggleFollow(int index) async {
    setState(() {
      searchlist[index]['isFollowing'] = !searchlist[index]['isFollowing'];
    });

    var followerId = searchlist[index]['_id'];
    if (searchlist[index]['isFollowing']) {
      await follow(followerId);
    } else {
      await unfollow(followerId);
    }
  }

  Future<void> follow(String followerId) async {
    var reqData = {
      'followerId': followerId};
    var response = await HomeService.follow(reqData);
    log.i('add to follow. $response');
  }

  Future<void> unfollow(String followerId) async {
    var reqData = {'followerId': followerId};
    var response = await HomeService.unfollow(reqData);
    log.i('removed from follow. $response');
  }

  // Function to handle text field changes
  void _onSearchTextChanged(String text) {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        searchlist = originalSearchList.where((result) =>
            result['firstName'].toLowerCase().contains(text.toLowerCase())).toList();
      });
    }
  }



  List<Map<String, dynamic>> _filterSearchResults(String query) {
    if (query.isEmpty) {
      // If the query is empty, return an empty list
      return [];
    } else {
      // Filter the search results based on the query
      return searchlist.where((result) =>
          result['firstName'].toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search", style: TextStyle(fontSize: 14)),
        actions: [],
      ),
      body: Column(
        children: [


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                color: blackshade,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey, // You can adjust the hint text color
                    fontSize: 14, // You can adjust the font size of the hint text
                  ),
                  border: InputBorder.none, // Remove the border
                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  suffixIcon: Icon(Icons.search),
                  // Center align the hint text
                ),
                textAlign: TextAlign.start, // Center align the text field
              ),
            ),
          ),
          SizedBox(height: 20,),

          Visibility(
            visible: searchlist.isEmpty && _searchController.text.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'No results found',
                style: TextStyle(
                  color: greybg,
                  fontSize: 12,
                ),
              ),
            ),
          ),


          Expanded(
            child: ListView.builder(
              itemCount: _searchController.text.isEmpty ? 0 : searchlist.length,
              itemBuilder: (BuildContext context, int index) {
                return MembersListing(
                  name: searchlist[index]['firstName'],
                  id: searchlist[index]['_id'],
                  status: searchlist[index]['isFollowing'],
                  img: searchlist[index]['profilePic'] != null
                      ? searchlist[index]['profilePic']['filePath']
                      : '',
                  onFollowToggled: () => toggleFollow(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





class MembersListing extends StatelessWidget {
  const MembersListing({
    required this.name,
    required this.img,
    required this.status,
    required this.id,
    required this.onFollowToggled,
    Key? key,
  }) : super(key: key);

  final String name;
  final String img;
  final String id;
  final bool status;
  final VoidCallback onFollowToggled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  profileinnerpage(
            id: id,
          )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5,),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: img.isNotEmpty
                      ? Image.network(
                    img,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                      : Image.network(
                    'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: onFollowToggled,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: status ? bluetext : buttoncolor,
                      ),
                      child: Text(
                        status ? 'Unfollow' : 'Follow',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: Colors.black,thickness: .1,),
            )
          ],
        ),
      ),
    );
  }
}
