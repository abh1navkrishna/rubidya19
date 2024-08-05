import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/color.dart';
import 'LandingPage.dart';
import 'login_page.dart';

class onboardingscreen extends StatefulWidget {
  const onboardingscreen({super.key});

  @override
  State<onboardingscreen> createState() => _onboardingscreenState();
}

class _onboardingscreenState extends State<onboardingscreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(

            children: [
              Image.asset(
                "assets/image/landingbg1.png",
                height: 314,
              ),


              SizedBox(height: 30,),


              Text(
                "Best Social app to make\nNew Friends",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: bluetext,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center, // Set the text alignment to center
              ),


              Text(
                "One of the best social apps for making\nfriends and personal business connections.",
                style: TextStyle(

                  color: textblack,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),
                textAlign: TextAlign.center, // Set the text alignment to center
              ),

              SizedBox(height: 40,),

              InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>login()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 48,
                    width: 400,
                    decoration: BoxDecoration(
                      color: buttoncolor,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Center(
                        child: Text("Get Started",
                          style: TextStyle(fontSize: 12,color: white,fontWeight: FontWeight.w600),)),
                  ),
                ),
              ),

              SizedBox(height: 40,),

            ],

          ),
        ),
      ),

    );
  }
}
