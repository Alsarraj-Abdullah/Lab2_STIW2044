import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:helloworld/SigninPage.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  SplashscreenPage createState() => new SplashscreenPage();
}

class SplashscreenPage extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //Splashscreen
    return new SplashScreen(
        seconds: 10,
        navigateAfterSeconds: new SigninPage(),
        title: new Text(
          'It\'s like Uber, but for haircuts!',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
        //Splashscreen Animated Logo
        image: new Image.asset('lyas.gif'),
        //Splashscreen Background Image
        imageBackground: new AssetImage('bg.png'),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        //Loader (Loading icon) Color
        loaderColor: Colors.red);
  }
}
