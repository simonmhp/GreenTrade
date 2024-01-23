import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green2/FB_Component/firebase_options.dart';
import 'package:green2/Initial/auth_page.dart';
import 'package:green2/Introduction/IntroductionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import your introduction screen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isFirstTime ? IntroductionScreen() : AuthPage(),
    ),
  );
}
