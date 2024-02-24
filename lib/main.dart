import 'package:camera/camera.dart';
import 'package:emotiondetector/splashs_screen.dart';
import 'package:flutter/material.dart';

List<CameraDescription>? cams;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cams = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Emotion Detector",
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
