import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:helloworld/HomePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:helloworld/SignupPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Text fields controllers
final TextEditingController loginUsernameField = TextEditingController();
final TextEditingController loginPasswordField = TextEditingController();
final TextEditingController resetEmailField = TextEditingController();

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  //Save prefrences variables
  bool rememberMe = false;
  bool _isChecked = false;
  String _loginUsername = '';
  String _loginPassword = '';

  void initState() {
    loadPrefrences();

    // print('Init: $_loginUsername');
    super.initState();
  }

  void resetEmail() {
    RegExp regex = new RegExp(Constants.pattern);

    if (resetEmailField.text != '') {
      if (regex.hasMatch(resetEmailField.text)) {
        http.post(Constants.resetURL, body: {
          "email": resetEmailField.text,
        }).then((res) {
          if (res.body == 'email_not_exist') {
//email_not_exist
            Toast.show(
                "The Email Address \"" +
                    resetEmailField.text +
                    "\" doesn't exist. Please check your input and try again.",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);
          } else if (res.body == 'failed') {
//failed
            Toast.show("Unknown error. Please try again later.", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } else if (res.body == 'success') {
            //success
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SigninPage()),
            );
            Toast.show(
                "Thanks! Please check \"" +
                    resetEmailField.text +
                    "\" for a link to reset your password.",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM);

            resetEmailField.text = '';
          }
          // print(res.body);
        }).catchError((err) {
          Toast.show("Network error. Please try again later.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show("Invalid Email Address.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      Toast.show("Email Address field cannot be empty.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void loadPrefrences() async {
    // print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loginUsername = (prefs.getString('user'));
    _loginPassword = (prefs.getString('pass'));
    //  print(_loginUsername);
    //  print(_loginPassword);
    if (_loginUsername != '') {
      loginUsernameField.text = _loginUsername;
      loginPasswordField.text = _loginPassword;
      setState(() {
        _isChecked = true;
      });
    } else {
      //  print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void savePrefrences(bool value) async {
    //  print('Inside savepref');
    _loginUsername = loginUsernameField.text;
    _loginPassword = loginPasswordField.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_loginUsername.length > 1 && (_loginPassword.length > 1)) {
        await prefs.setString('user', _loginUsername);
        await prefs.setString('pass', _loginPassword);
        //  print('Save pref $_loginUsername');
        //  print('Save pref $_loginPassword');
        Toast.show("Preferences have been saved.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        //  print('No username');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Invalid credentials.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('user', '');
      await prefs.setString('pass', '');
      setState(() {
        loginUsernameField.text = '';
        loginPasswordField.text = '';
        _isChecked = false;
      });
      //  print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _onRememberMeChange(bool value) {
    setState(() {
      _isChecked = value;
      savePrefrences(value);
    });
  }

  void rememberMeChanged(bool value) => setState(() => rememberMe = value);
  Widget build(BuildContext context) {
    void _signinButton() {
      //If login fields are not empty.
      if (loginUsernameField.text != '' && loginPasswordField.text != '') {
        //If username and password are correct.

        Size size = MediaQuery.of(context).size;
        http.post(Constants.loginURL, body: {
          "username": loginUsernameField.text,
          "password": loginPasswordField.text,
        }).then((res) {
          //  print(res.statusCode);
          print(res.body);
          var parsedJson = json.decode(res.body);
          var profilepicLink = parsedJson['Profile_pic'];
          var statusInfo = parsedJson['status'];
          var email = parsedJson['Email'];
          var balance = parsedJson['Balance'];
          // print(profilepicLink);
          print(balance);

          if (statusInfo == 'loggedIn') {
            setState(() {
              HomePage.drawerProfilepic = profilepicLink;
              HomePage.loggedBalance = int.parse(balance);
              HomePage.isLoggedin = true;
              HomePage.loggedUsername = loginUsernameField.text;
              HomePage.loggedEmail = email;
              HomePage.signinButtonText = 'Sign Out';
              HomePage.sliderHeight = 343;
            });
            Alert(
              context: context,
              type: AlertType.success,
              closeFunction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              title: "Sign-in confirmed!",
              desc: "Welcome " +
                  loginUsernameField.text +
                  "! You're now ready to use MyBarber. 💈😎",
              content: Column(children: <Widget>[
                SizedBox(height: 20),
                CircleAvatar(
                  backgroundColor: Colors.red[600],
                  radius: size.width / 6.1,
                  child: CircleAvatar(
                    radius: size.width / 6.5,
                    backgroundColor: Colors.red[600],
                    backgroundImage: NetworkImage(profilepicLink),
                  ),
                ),
              ]),
              buttons: [
                DialogButton(
                  color: Colors.green[400],
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                  width: 150,
                )
              ],
            ).show();
          } else if (statusInfo == 'loginFailed') {
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
          } else {
            Alert(
              context: context,
              type: AlertType.error,
              title: "Failed!",
              desc: "Unknown error occurred. Please try again later!",
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
          }
        }).catchError((err) {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Failed!",
            desc: "Unknown error occurred. Please try again later!",
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
        });
      } else {
        //If login fields are empty.
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

//Signup text URL Launcher.

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              //Main screen Background Image
              child: new Image.asset(
                'bg.png',
                width: size.width,
                height: size.height,

                //Image repeat: to make a pattern style image.
                repeat: ImageRepeat.repeat,
              ),
            ),
            Center(
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20.0),
                  child: Column(children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Image.asset('logo.png',
                          height: size.height / 2.5,
                          width: size.height / 2.5,
                          alignment: Alignment.center,
                          fit: BoxFit.fill),
                    ),
                    SizedBox(height: 30),
                    TextField(
                        controller: loginUsernameField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        decoration: InputDecoration(
                            hintText: 'Username',
                            //filled: to make a background color for text fields.
                            filled: true,
                            //withOpacity: to make the color transparent.
                            fillColor: Colors.white.withOpacity(0.5),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                            //prefixIcon: to set an icon for text field.
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue[600],
                            ))),
                    SizedBox(height: 20),
                    TextField(
                        controller: loginPasswordField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        //obscureText: to hide password chars for password text field.
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                          border: OutlineInputBorder(
                              //borderRadius: To make round corners for text field.
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue[600],
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: CheckboxListTile(
                          value: _isChecked,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('Remember Me',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue[600])),
                          onChanged: (bool value) {
                            _onRememberMeChange(value);
                          },
                        )),
                    CupertinoButton(
                      child: Text("Sign In"),
                      color: Colors.red[600],
                      onPressed: _signinButton,
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    FlatButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          type: AlertType.info,
                          title: "Trouble Logging In?",
                          desc:
                              "Enter your email and we'll send you a link to get back into your account.",
                          content: Column(children: <Widget>[
                            SizedBox(height: 20),
                            TextFormField(
                                controller: resetEmailField,
                                style: TextStyle(
                                    color: Colors.blue[600], fontSize: 15),
                                decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    //filled: to make a background color for text fields.
                                    filled: true,
                                    //withOpacity: to make the color transparent.
                                    fillColor: Colors.white.withOpacity(0.5),
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    //prefixIcon: to set an icon for text field.
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.blue[600],
                                    )))
                          ]),
                          buttons: [
                            DialogButton(
                              color: Colors.green[400],
                              child: Text(
                                "Send Link",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              onPressed: () => resetEmail(),
                              width: 150,
                            )
                          ],
                        ).show();
                      },
                      child: Text("Forgot your password?",
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 13,
                              decoration: TextDecoration.underline)),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
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
      ),
    );
  }
}
