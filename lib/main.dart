import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note/src/app_root.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAm-nETRJqpXgVNaovYXmwfECE_olhF7ho",
    appId: "1:805320937983:android:06e8fc44f24eacdab757ca",
    messagingSenderId: "805320937983",
    projectId: "authentication-dd9c2",
  ));
  runApp(const AppRoot());
}
