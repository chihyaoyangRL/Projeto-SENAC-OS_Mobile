import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ordem_services/screen/splashscreen.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}
