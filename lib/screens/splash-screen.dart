import 'package:flutter/material.dart';
import '../loader/color_loader_3.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ColorLoader3(),
      ),
    );
  }
}
