import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/authentication/login.dart';

import 'home_page.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4,),
            () => Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)
                ? const HomePage()
                : const Login();
          },
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("الشوربجي",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: MediaQuery.of(context).size.height*0.2,),
              const Text("note_app",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
               SizedBox(
                 height: MediaQuery.of(context).size.height*0.02,
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.37,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.27,
                child: Image.asset("images/note12.png", fit: BoxFit.fill,),
              ),
            ],
          )
      ),
    );
  }
}

