import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:threads/common/locator.dart';
import 'package:threads/common/splash.dart';
import 'package:threads/state/app.state.dart';
import 'package:threads/state/auth.state.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/state/search.state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as d;

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  if (d.Platform.isIOS)
    Firebase.initializeApp();
  else
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBQ68_qY1qYrYvXalCrrbXZwgB5NlZJ94w",
            authDomain: "threads-instagram.firebaseapp.com",
            databaseURL:
                "https://threads-instagram-default-rtdb.firebaseio.com",
            projectId: "threads-instagram",
            storageBucket: "threads-instagram.appspot.com",
            messagingSenderId: "799971967226",
            appId: "1:799971967226:web:122c3ae661013c38d50943",
            measurementId: "G-J8Y7QJK62L"));
  setupDependencies();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStates>(create: (_) => AppStates()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<PostState>(create: (_) => PostState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
      ],
      child: MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          title: 'Threads',
          debugShowCheckedModeBanner: false,
          home: SplashPage()),
    );
  }
}
