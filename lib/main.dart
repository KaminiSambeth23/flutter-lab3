
import 'package:flutter/material.dart';
import 'package:carpool/splashscreen.dart';
void main() {
  runApp(SplashScreenApp());
}
class SplashScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stateless Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
     
); 
  }
}