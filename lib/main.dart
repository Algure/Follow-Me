import 'package:flutter/material.dart';
import 'package:follow_me/screens/home_screen.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Follow Me',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Home'),
      ),
    );
  }
}

