import 'package:flutter/material.dart';

class contactpage extends StatefulWidget {
  const contactpage({super.key});

  @override
  State<contactpage> createState() => _contactpageState();
}

class _contactpageState extends State<contactpage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(


      appBar: AppBar(
        automaticallyImplyLeading: false, // This will add a default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start
          ,
          children: [
            Text("Contact", style: TextStyle(fontSize: 14),),
          ],
        ),
      ),
      body: Center(
        child: Text("The Contact  Feature Will be Released Soon..."),
      ),

    );
  }
}