import 'package:flutter/material.dart';

class reelpage extends StatefulWidget {
  const reelpage({super.key});

  @override
  State<reelpage> createState() => _reelpageState();
}

class _reelpageState extends State<reelpage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(
        automaticallyImplyLeading: true, // This will add a default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start
          ,
          children: [
            Text("Reels", style: TextStyle(fontSize: 14),),
          ],
        ),
      ),
      body: Center(
        child: Text("This Feature Will be Released Soon..."),
      ),

    );
  }
}