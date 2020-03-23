import 'package:flutter/material.dart';
import '../loader/color_loader_3.dart';
import 'dart:async';
import './home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, routeHome);
  }

  routeHome() {
    Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
  }

  @override
  void initState() {
    // startTime();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ColorLoader3(),
      ),
    );
  }
}
