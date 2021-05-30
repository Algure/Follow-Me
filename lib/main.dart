import 'package:flutter/material.dart';
import 'package:follow_me/screens/home_screen.dart';
import 'package:follow_me/screens/login_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Follow Me',
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),//MyHomePage(title: 'Home'),
        builder: EasyLoading.init(),
      ),
    );
  }
}

