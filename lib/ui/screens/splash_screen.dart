import 'package:chat_app/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1000), () {
      if (user != null) {
        print(user!.displayName);
        Navigator.pushReplacementNamed(context, homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, signInScreen);
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 90.0),
                      height: 420,
                      width: 420.0,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(300.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/chatty-logo.png'),
                        ),
                        shape: BoxShape.circle,
                      ),
                      // child: Image.asset('assets/images/ElRowadFarm-logos.jpeg',height: 30.0.h,width: 80.0.w,)),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                ],
              ),

// SizedBox(height: 30.0.h,),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/slovic.png',
                    height: 100.0,
                    width: 100.0,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
