import 'package:flutter/material.dart';

class messagepage extends StatefulWidget {
  const messagepage({super.key});

  @override
  State<messagepage> createState() => _messagepageState();
}

class _messagepageState extends State<messagepage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(
        automaticallyImplyLeading: false, // This will add a default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start
          ,
          children: [
            Text("Messages", style: TextStyle(fontSize: 14),),
          ],
        ),
      ),
      body: Center(
        child: Text("The Meassage feature Will be Released Soon..."),
      ),

    );
  }
}