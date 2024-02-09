import 'package:flutter/material.dart';
import 'package:flutter_webrtc_app/screens/home_screen.dart';

void main() {
  // start videoCall app
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
