import 'package:flutter/material.dart';
import 'package:sqlite_project/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SQLITE Project',
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
