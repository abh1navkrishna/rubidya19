import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/Chat_service.dart';
import '../../services/Search_service.dart';
import 'chatpage.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<MessagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> conversationData = [];
  bool isLoading = true;
  late List<Map<String, dynamic>> searchlist = [];
  late List<Map<String, dynamic>> originalSearchList = [];
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    fetchChatHistory();
    _initLoad();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initLoad() async {
    await _searchFollowList();
  }

  Future<void> fetchChatHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userid');
      String? token = prefs.getString('token');
      if (userId == null || token == null) {
        throw Exception("User ID or token not found");
      }
      var data = await ChatService.getChatHistory(page: 1, limit: 10);
      setState(() {
        conversationData = data['conversationData'];
        print('.........');
        print(conversationData);

        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchFollowList() async {
    try {
      var response = await SearchService.searchpage();
      if (mounted) {
        setState(() {
          originalSearchList =
          List<Map<String, dynamic>>.from(response['result']);
          searchlist = List<Map<String, dynamic>>.from(originalSearchList);
        });
      }
    } catch (e) {
      print('Error fetching search data: $e');
    }
  }

  void _onSearchTextChanged(String text) {
    if (mounted) {
      setState(() {
        searchlist = originalSearchList
            .where((result) =>
        result['firstName']?.toLowerCase().contains(text.toLowerCase()) ?? false)
            .toList();
      });
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString).toUtc(); // Parse as UTC
    DateTime istDateTime =
    dateTime.add(Duration(hours: 5, minutes: 30)); // Convert to IST
    return DateFormat('HH:mm').format(istDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            collapsedHeight: 100,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1E3167),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
              ],
            ),
            floating: true,
            snap: true,
            expandedHeight: screenHeight * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: _onSearchTextChanged,
                      decoration: InputDecoration(
                          fillColor: Color(0x3AA3D4FF),
                          filled: true,
                          hintText: 'Search...',
                          suffixIcon: Icon(
                            Icons.search,
                            color: Color(0xffA3D4FF),
                          ),
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Color(0xffA7ACD0)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0x3AA3D4FF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0x3AA3D4FF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          border: const OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (searchlist.isNotEmpty && _searchController.text.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var searchResult = searchlist[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversationId: searchResult['_id'],
                            userId: searchResult['userId'] ?? '',
                            userName: searchResult['firstName'] ?? '',
                            profilePic: searchResult['profilePic'] != null
                                ? searchResult['profilePic']['filePath'] ?? ''
                                : null,
                          ),
                        ),
                      );
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: searchResult['profilePic'] != null
                            ? Image.network(
                          searchResult['profilePic']['filePath'] ?? '',
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      searchResult['firstName'] ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff1E3167)),
                    ),
                  );
                },
                childCount: searchlist.length,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var conversation = conversationData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            conversationId: conversation['_id'],
                            userId: conversation['userId'] ?? '',
                            userName: conversation['interactedUser'] ?? '',
                            profilePic: conversation['profilePic'] ?? '',
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 42,
                          width: 42,
                          child: conversation['profilePic'] != null
                              ? Image.network(
                            conversation['profilePic'] ?? '',
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        conversation['interactedUser'] ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xff1E3167)),
                      ),
                      subtitle: Text(
                        'Hello',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff8996BC)),
                      ),
                      trailing
                          : Text(
                        formatDateTime(conversationData[index]['updatedAt']),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff8996BC)),
                      ),
                    ),
                  );
                },
                childCount: conversationData.length,
              ),
            ),
        ],
      ),
    );
  }
}
