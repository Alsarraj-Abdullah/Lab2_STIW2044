import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
final TextEditingController usernameField = TextEditingController();
final TextEditingController passwordField = TextEditingController();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 15,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          'It\'s like Uber, but for haircuts!',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
        image: new Image.asset('lyas.gif'),
        imageBackground: new AssetImage('bg.png'),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 200.0,
        loaderColor: Colors.red);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _pressMe() {
      if(usernameField.text != '' && passwordField.text != ''){
//full fields
if (usernameField.text == 'abdullah' && passwordField.text == '123456') {
Alert(
      context: context,
      type: AlertType.success,
      
      title: "Sign-in confirmed!",
      desc: "Welcome " + usernameField.text +"! You're now ready to use MyBarber.",
      buttons: [
        DialogButton(
          color: Colors.green[400],
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 150,
        )
      ],
    ).show();
  }else{
    //Invalid username/password!
    Alert(
      context: context,
      type: AlertType.error,
      
      title: "Oops!",
      desc: "Incorrect Username/Password, Please try again!",
      buttons: [
        DialogButton(
          color: Colors.red[400],
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 150,
        )
      ],
    ).show();
  }
      }else{
Alert(
      context: context,
      type: AlertType.warning,
      
      title: "All fields are required.",
      desc: "One or both fields are empty, Please try again!",
      buttons: [
        DialogButton(
          color: Colors.yellow[600],
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 150,
        )
      ],
    ).show();
      }
      
    }
    _launchURL() async {
      const url = 'https://sharpns.net';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'bg.png',
              width: size.width,
              height: size.height,
              repeat: ImageRepeat.repeat,
            ),
          ),
          Center(
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(30.0),
                width: 550,
                height: 850,
                child: Column(children: <Widget>[
                  Image.asset('logo.png',
                      height: 300.0,
                      width: 300.0,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover),
                  SizedBox(height: 90),
                  TextField(
                    controller: usernameField,
                      style: TextStyle(color: Colors.blue[600], fontSize: 15),
                      decoration: InputDecoration(
                          hintText: 'Username',
                          filled: true,
                          
                          fillColor: Colors.white.withOpacity(0.5),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: Icon(Icons.person,color:  Colors.blue[600],))),
                  SizedBox(height: 20),
                  TextField(
                     controller: passwordField,
                      style: TextStyle(color: Colors.blue[600], fontSize: 15),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: OutlineInputBorder(
                          
                            borderRadius: BorderRadius.circular(30)),
                        prefixIcon: Icon(Icons.lock,color: Colors.blue[600],),
                      )),
                  SizedBox(height: 30),
                  CupertinoButton(
                    child: Text("Sign In"),
                    color: Colors.red[600],
                    onPressed: _pressMe,
                    
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  FlatButton(
                    onPressed: _launchURL,
                    child: Text("Don\'t have an account? Join Us!",
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 13,
                            decoration: TextDecoration.underline)),
                  ),
                ])),
          ),
        ],
      ),
    );
  }
}
