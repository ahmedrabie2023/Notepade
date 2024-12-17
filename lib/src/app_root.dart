import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note/authentication/login.dart';
import 'package:note/screens/home_page.dart';
import 'package:note/screens/splash_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!=====================');
      } else {
        print('User is signed in!=================================');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(
                color: Colors.orange,
              ),
              actionsIconTheme:
                  const IconThemeData(color: Colors.orange, size: 25),
              backgroundColor: Colors.grey[50],
              titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 20)),
          fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen()
    );
  }
}
