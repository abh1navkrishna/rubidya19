import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../resources/color.dart';
import '../../services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String conversationId;
  final String userName;
  final String profilePic;

  ChatPage({
    required this.userId,
    required this.conversationId,
    required this.userName,
    required this.profilePic,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController =
      TextEditingController(); // Controller for text input

  @override
  void initState() {
    super.initState();
    fetchMessages(widget.conversationId);
    // _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   fetchMessages(widget.conversationId);
    // });
    fetchMessages(widget.conversationId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages(String conversationId) async {
    try {
      var data =
          await ChatService.getMessages(conversationId, page: 1, limit: 10);
      print("Fetched data: $data");
      setState(() {
        messages = List<Map<String, dynamic>>.from(data['messages']);
        messages = messages.reversed.toList();
        isLoading = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print("Error fetching messages: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('userid');

    print('$loginId');
    if (loginId == null) {
      print("No login ID found in SharedPreferences");
      return;
    }

    try {
      var response =
          await ChatService.sendMessage(loginId, message, widget.userId);
      print("Message sent successfully: $response");

      _messageController.clear();

      fetchMessages(widget.conversationId);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    final alignment = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final color = isMe ? Colors.grey[300] : Colors.green[100];
    final margin = isMe
        ? EdgeInsets.only(right: 50, top: 8, bottom: 8)
        : EdgeInsets.only(left: 50, top: 8, bottom: 8);

    var createdAt = message["createdAt"] != null
        ? DateTime.parse(message["createdAt"])
        : DateTime.now();

    var formattedDate = DateFormat.yMd().add_jms().format(createdAt);

    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: margin,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              message["message"] ?? 'No message',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              gradient: LinearGradient(
                colors: [Color(0xff1E3167), Color(0xE21E1889)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 42,
                      width: 42,
                      child: (widget.profilePic != null &&
                              widget.profilePic.isNotEmpty)
                          ? Image.network(
                              widget.profilePic,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8=w600-h300-pc0xffffff-pd',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(100),
                  //   child: Container(
                  //     height: 42,
                  //     width: 42,
                  //     child: widget.profilePic != null
                  //         ? Image.network(
                  //       widget.profilePic!,
                  //       fit: BoxFit.cover,
                  //     )
                  //         : Image.network(
                  //       'https://play-lh.googleusercontent.com/4HZhLFCcIjgfbXoVj3mgZdQoKO2A_z-uX2gheF5yNCkb71wzGqwobr9muj8I05Nc8u8=w600-h300-pc0xffffff-pd',
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5)
            ],
          ),
          actions: [SizedBox(width: 20)],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final isMe = messages[index]['senderId'] == widget.userId;
                      return _buildMessage(messages[index], isMe);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      color: Color(0x3AA3D4FF),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Message',
                                  hintStyle: TextStyle(
                                    color: Color(0xff8996BC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/svg/Vector.svg',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              String message = _messageController.text.trim();
                              if (message.isNotEmpty) {
                                sendMessage(message);
                              }
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: bluetext,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
