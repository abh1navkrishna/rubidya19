import 'package:flutter/material.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';

class BlockedAccountsPage extends StatefulWidget {
  @override
  _BlockedAccountsPageState createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  List<dynamic> blockedUsers = [];
  bool isLoading = true;
  int page = 1;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    fetchBlockedUsers();
  }

  Future<void> fetchBlockedUsers() async {
    try {
      var data = await ProfileService.getBlockedUsers(page: page, limit: limit);
      setState(() {
        blockedUsers = data['result'];
        isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> unblockUser(String userId) async {
    try {
      var reqData = {'user': userId};
      var response = await ProfileService.unblockuser(reqData);
      print('User unblocked: $response');
      setState(() {
        blockedUsers.removeWhere((user) => user['userId'] == userId);
      });
    } catch (e) {
      // Handle error appropriately
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Blocked Accounts',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            SizedBox(width: 20,)
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: blockedUsers.length,
        itemBuilder: (context, index) {
          var user = blockedUsers[index];
          return Card(
            color: white,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['profilePic']),
              ),
              title: Text('${user['firstName']} ',style: TextStyle(
                  color:  bluetext,
                  fontWeight: FontWeight.w500)
                ,),
              trailing: GestureDetector(
                onTap: () {
                  unblockUser(user['userId']);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: greybg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Unblock',
                    style: TextStyle(color: bluetext),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}