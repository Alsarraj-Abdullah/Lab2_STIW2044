import 'dart:io';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

//Text fields controllers
final TextEditingController loginUsernameField = TextEditingController();
final TextEditingController loginPasswordField = TextEditingController();
final TextEditingController registerUsernameField = TextEditingController();
final TextEditingController registerPassword1Field = TextEditingController();
final TextEditingController registerPassword2Field = TextEditingController();
final TextEditingController registerEmailField = TextEditingController();

class SplashscreenPage extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //Splashscreen
    return new SplashScreen(
        //Splashscreen Delay : 15 secs
        /////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////
        seconds: 5,
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

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  static const String loginURL =
      'https://sharpns.net/mybarber3/php/login_user.php';
  bool rememberMe = false;
  bool _isChecked = false;
  String _loginUsername = '';
  String _loginPassword = '';
  void initState() {
    loadpref();
    print('Init: $_loginUsername');
    super.initState();
  }

 

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loginUsername = (prefs.getString('user'));
    _loginPassword = (prefs.getString('pass'));
    print(_loginUsername);
    print(_loginPassword);
    if (_loginUsername != null) {
      loginUsernameField.text = _loginUsername;
      loginPasswordField.text = _loginPassword;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _loginUsername = loginUsernameField.text;
    _loginPassword = loginPasswordField.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //true save pref
      if (_loginUsername.length > 1 && (_loginPassword.length > 1)) {
        await prefs.setString('user', _loginUsername);
        await prefs.setString('pass', _loginPassword);
        print('Save pref $_loginUsername');
        print('Save pref $_loginPassword');
        Toast.show("Preferences have been saved.", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No username');
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
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void rememberMeChanged(bool value) => setState(() => rememberMe = value);
  Widget build(BuildContext context) {
    void _signinButton() {
      //If login fields are not empty.
      if (loginUsernameField.text != '' && loginPasswordField.text != '') {
        //If username and password are correct.

        Size size = MediaQuery.of(context).size;
        http.post(loginURL, body: {
          "username": loginUsernameField.text,
          "password": loginPasswordField.text,
        }).then((res) {
          print(res.statusCode);
          print(res.body);
          var parsedJson = json.decode(res.body);
          var profilepicLink = parsedJson['Profile_pic'];
          var statusInfo = parsedJson['status'];

          print(profilepicLink);
          print(statusInfo);

          if (statusInfo == 'loggedIn') {
            Alert(
              context: context,
              type: AlertType.success,
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
                  onPressed: () => Navigator.pop(context),
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
                    Image.asset('logo.png',
                        height: size.height / 2.5,
                        width: size.height / 2.5,
                        alignment: Alignment.center,
                        fit: BoxFit.fill),
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
                            _onChange(value);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                        );
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

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Color usernameColor = Colors.white.withOpacity(0);
  Color emailColor = Colors.white.withOpacity(0);
  Color passwordColor = Colors.white.withOpacity(0);
  Color confirmColor = Colors.white.withOpacity(0);
  IconData usernameIcon = Icons.close;
  IconData emailIcon = Icons.close;
  IconData passwordIcon = Icons.close;
  IconData confirmIcon = Icons.close;
  double iconOpacity = 0.0;
  File _imageFile;

  // To track the file uploading state
  void initState() {
    super.initState();
  }

  _onSignupAlertPressed(context) {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SigninPage()),
        );
      });
    });
  }

  String generateFileName(String input) {
    final mimeTypeData =
        lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    return md5.convert(utf8.encode(timestamp + input)).toString() +
        '.' +
        mimeTypeData[1];
  }

  String imageName;
  static const String imageUploadURL =
      'https://sharpns.net/mybarber3/php/upload_image.php';
  static const String registerURL =
      'https://sharpns.net/mybarber3/php/register_user.php';

  static const String checkUsernameURL =
      "https://sharpns.net/mybarber3/php/check_username.php";
  static const String checkEmailURL =
      "https://sharpns.net/mybarber3/php/check_email.php";
  static const String defaultPic =
      'https://sharpns.net/mybarber3/images/profilepic.png';
  bool emailTaken = false;
  bool usernameTaken = false;
  Future<Map<String, dynamic>> _uploadImage(File image) async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(imageUploadURL));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

    imageUploadRequest.fields['ext'] = imageName;
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  _startUploading() async {
    final Map<String, dynamic> response = await _uploadImage(_imageFile);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Toast.show("Profile Picture upload failed.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return false;
    } else {
      return true;
      // print(imagePath);
    }
  }

  void _signupButton() async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    //If login fields are not empty.
    if (registerUsernameField.text != '' &&
        registerEmailField.text != '' &&
        registerPassword1Field.text != '' &&
        registerPassword2Field.text != '') {
      if (registerPassword1Field.text != registerPassword2Field.text) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Oops!",
          desc: "Passwords didn't match, Please try again!",
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
      } else if (!regex.hasMatch(registerEmailField.text)) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Oops!",
          desc: "The email address is invalid, Please try again!",
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
        if (emailTaken == true) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Email Unavailable!",
            desc:
                "The Email is already registered. Please try another one, or reset your password!",
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
        } else if (usernameTaken == true) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Username Unavailable!",
            desc: "This username is already taken, Please try another one!",
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
        } else if ((emailTaken == false) && (usernameTaken == false)) {
          if (_imageFile != null) {
            final imageUploadStatus = await _startUploading();
            if (imageUploadStatus == true) {
              http.post(registerURL, body: {
                "name": registerUsernameField.text,
                "email": registerEmailField.text,
                "password": registerPassword1Field.text,
                "profilepic":
                    'https://sharpns.net/mybarber3/images/' + imageName,
              }).then((res) {
                print(res.statusCode);

                if (res.statusCode == 200) {
                  Alert(
                    context: context,
                    style: AlertStyle(isCloseButton: false),
                    type: AlertType.success,
                    title: "Signup Successful!",
                    desc: "Welcome " +
                        registerUsernameField.text +
                        "! We have sent you a message to \"" +
                        registerEmailField.text +
                        "\". Please verify your email address before using your account. Enjoy MyBarber!",
                    buttons: [
                      DialogButton(
                        color: Colors.green[400],
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => _onSignupAlertPressed(context),
                        width: 150,
                      )
                    ],
                  ).show();
                  loginUsernameField.text = registerUsernameField.text;
                  loginPasswordField.text = registerPassword1Field.text;
                  registerUsernameField.text = '';
                  registerEmailField.text = '';
                  registerPassword1Field.text = '';
                  registerPassword2Field.text = '';
                } else if (res.statusCode == 400) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Signup Failed!",
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
                  title: "Signup Failed!",
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
            }
          } else {
            http.post(registerURL, body: {
              "name": registerUsernameField.text,
              "email": registerEmailField.text,
              "password": registerPassword1Field.text,
              "profilepic": defaultPic,
            }).then((res) {
              print(res.statusCode);

              if (res.statusCode == 200) {
                Alert(
                  context: context,
                  style: AlertStyle(isCloseButton: false),
                  type: AlertType.success,
                  title: "Signup Successful!",
                  desc: "Welcome " +
                      registerUsernameField.text +
                      "! We have sent you a message to \"" +
                      registerEmailField.text +
                      "\". Please verify your email address before using your account. Enjoy MyBarber!",
                  buttons: [
                    DialogButton(
                      color: Colors.green[400],
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => _onSignupAlertPressed(context),
                      width: 150,
                    )
                  ],
                ).show();
                loginUsernameField.text = registerUsernameField.text;
                loginPasswordField.text = registerPassword1Field.text;
                registerUsernameField.text = '';
                registerEmailField.text = '';
                registerPassword1Field.text = '';
                registerPassword2Field.text = '';
              } else if (res.statusCode == 400) {
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Signup Failed!",
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
                title: "Signup Failed!",
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
          }
        }
      }
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

  Widget _decideImageView() {
    Size size = MediaQuery.of(context).size;
    if (_imageFile == null) {
      return CircleAvatar(
        backgroundColor: Colors.red[600],
        radius: size.width / 5.1,
        child: CircleAvatar(
          radius: size.width / 5.5,
          backgroundColor: Colors.red[600],
          backgroundImage: AssetImage('profilepic.png'),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.red[600],
        radius: size.width / 5.1,
        child: CircleAvatar(
          radius: size.width / 5.5,
          backgroundColor: Colors.red[600],
          backgroundImage: FileImage(_imageFile),
        ),
      );
    }
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 500.0, maxHeight: 500.0);

    this.setState(() {
      _imageFile = picture;
    });
    if (_imageFile != null) {
      imageName = generateFileName(_imageFile.path);
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 500.0, maxHeight: 500.0);
    this.setState(() {
      _imageFile = picture;
    });
    imageName = generateFileName(_imageFile.path);
    Navigator.of(context).pop();
  }

  clearImage() async {
    this.setState(() {
      _imageFile = null;
    });
    Navigator.of(context).pop();
  }

  // void initState() {
  //   super.initState();
  // }

  void validateUsername(String value) {
    usernameIcon = Icons.close;
    usernameColor = Colors.white.withOpacity(0);
    usernameTaken = false;
    String usernameText = registerUsernameField.text;
    if (usernameText.length == 0) {
      usernameIcon = Icons.close;
      usernameColor = Colors.white.withOpacity(0);
      usernameTaken = false;
      return null;
    }
    if ((registerUsernameField.text != '')) {
      http.post(checkUsernameURL, body: {
        "username": usernameText,
      }).then((res) {
        if (res.statusCode != 408) {
          print(res.body);
          var parsedJson = json.decode(res.body);
          var status = parsedJson['status'];
          if (status == 'available') {
            usernameIcon = Icons.check;
            usernameColor = Colors.green.withOpacity(1);
            usernameTaken = false;
            return null;
          } else if (status == 'taken') {
            usernameIcon = Icons.info_outline;
            usernameColor = Colors.yellow[600].withOpacity(1);
            usernameTaken = true;
            return null;
          } else if (status == 'error') {
            usernameIcon = Icons.close;
            usernameColor = Colors.red[600].withOpacity(1);
            usernameTaken = false;
            return null;
          }
        } else {
          usernameIcon = Icons.close;
          usernameColor = Colors.red[600].withOpacity(1);
          usernameTaken = false;
        }
      }).catchError((err) {
        usernameIcon = Icons.close;
        usernameColor = Colors.red[600].withOpacity(1);
        usernameTaken = false;
        return null;
      });
    }
    return null;
  }

  void validateEmail(String value) {
    emailIcon = Icons.close;
    emailColor = Colors.white.withOpacity(0);
    emailTaken = false;
    String emailText = registerEmailField.text;
    if (emailText.length == 0) {
      emailIcon = Icons.close;
      emailColor = Colors.white.withOpacity(0);
      emailTaken = false;
      return null;
    }
    if ((registerEmailField.text != '')) {
      http.post(checkEmailURL, body: {
        "email": emailText,
      }).then((res) {
        if (res.statusCode != 408) {
          print(res.body);
          var parsedJson = json.decode(res.body);
          var status = parsedJson['status'];
          if (status == 'available') {
            emailIcon = Icons.check;
            emailColor = Colors.green.withOpacity(1);
            emailTaken = false;
            return null;
          } else if (status == 'taken') {
            emailIcon = Icons.info_outline;
            emailColor = Colors.yellow[600].withOpacity(1);
            emailTaken = true;
            return null;
          } else if (status == 'error') {
            emailIcon = Icons.close;
            emailColor = Colors.red[600].withOpacity(1);
            emailTaken = false;
            return null;
          }
        } else {
          emailIcon = Icons.close;
          emailColor = Colors.red[600].withOpacity(1);
          emailTaken = false;
        }
      }).catchError((err) {
        emailIcon = Icons.close;
        emailColor = Colors.red[600].withOpacity(1);
        emailTaken = false;
        return null;
      });
    }
    return null;
  }

  void validatePassword(String value) {
    if (registerPassword1Field.text == registerPassword2Field.text) {
      passwordIcon = Icons.check;
      confirmIcon = Icons.check;
      passwordColor = Colors.green.withOpacity(1);
      confirmColor = Colors.green.withOpacity(1);
    }
    if (registerPassword1Field.text != registerPassword2Field.text) {
      passwordIcon = Icons.check;
      confirmIcon = Icons.close;
      passwordColor = Colors.green.withOpacity(1);
      confirmColor = Colors.red.withOpacity(1);
    }
    if (registerPassword1Field.text == '' ||
        registerPassword2Field.text == '') {
      passwordColor = Colors.green.withOpacity(0);
      confirmColor = Colors.green.withOpacity(0);
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose Image Source"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Clear"),
                    onTap: () {
                      clearImage();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
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
                  //    width: 550,
                  // height: size.height,
                  child: Column(children: <Widget>[
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: _decideImageView(),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                        controller: registerUsernameField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        onFieldSubmitted: (value) {
                          setState(() => validateUsername(value));
                        },
                        validator: (value) {
                          if (registerUsernameField.text == '') {
                            usernameIcon = Icons.close;
                            usernameColor = Colors.white.withOpacity(0);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon:
                                Icon(usernameIcon, color: usernameColor),
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
                    SizedBox(height: 15),
                    TextFormField(
                        controller: registerEmailField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        onFieldSubmitted: (value) {
                          setState(() => validateEmail(value));
                        },
                        validator: (value) {
                          if (registerEmailField.text == '') {
                            emailIcon = Icons.close;
                            emailColor = Colors.white.withOpacity(0);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(emailIcon, color: emailColor),
                            hintText: 'Email Address',
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
                              Icons.email,
                              color: Colors.blue[600],
                            ))),
                    SizedBox(height: 15),
                    TextField(
                      controller: registerPassword1Field,
                      style: TextStyle(color: Colors.blue[600], fontSize: 15),
                      //obscureText: to hide password chars for password text field.
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => validatePassword(value));
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(passwordIcon, color: passwordColor),
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
                          )),
                    ),
                    SizedBox(height: 15),
                    TextField(
                        controller: registerPassword2Field,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        //obscureText: to hide password chars fodr password text field.
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => validatePassword(value));
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          filled: true,
                          suffixIcon: Icon(confirmIcon, color: confirmColor),
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
                    SizedBox(height: 30),
                    CupertinoButton(
                      child: Text("Sign Up"),
                      color: Colors.red[600],
                      onPressed: _signupButton,
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SigninPage()),
                        );
                      },
                      child: Text("Already registered? Click here to sign in.",
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
