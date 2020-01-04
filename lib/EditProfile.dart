import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:helloworld/SigninPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:helloworld/HomePage.dart';

//Text fields controllers
final TextEditingController editUsernameField = TextEditingController();
final TextEditingController editPassword1Field = TextEditingController();
final TextEditingController editPassword2Field = TextEditingController();
final TextEditingController editEmailField = TextEditingController();

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //Text fields suffix style variables
  Color usernameColor = Colors.white.withOpacity(0);
  Color emailColor = Colors.white.withOpacity(0);
  Color passwordColor = Colors.white.withOpacity(0);
  Color confirmColor = Colors.white.withOpacity(0);
  IconData usernameIcon = Icons.close;
  IconData emailIcon = Icons.close;
  IconData passwordIcon = Icons.close;
  IconData confirmIcon = Icons.close;
  //Profile picture file variable
  File _imageFile;
//Profile picture name variable
  String imageName;

  bool emailTaken = false;
  bool usernameTaken = false;
  // To track the file uploading state
  void initState() {
    super.initState();
  }



  String generateFileName(String input) {
    final mimeTypeData =
        lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    return md5.convert(utf8.encode(timestamp + input)).toString() +
        '.' +
        mimeTypeData[1];
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(Constants.imageUploadURL));
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
      //  print(e);
      return null;
    }
  }

  _startUploading() async {
    final Map<String, dynamic> response = await _uploadImage(_imageFile);
    // print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Toast.show("Profile Picture upload failed.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return false;
    } else {
      print(imageName);
      return true;
    }
  }

  void _saveButton() async {
    RegExp regex = new RegExp(Constants.pattern);

    //If login fields are not empty.
    if (editUsernameField.text != '' &&
        editEmailField.text != '' &&
        editPassword1Field.text != '' &&
        editPassword2Field.text != '') {
      if (editPassword1Field.text != editPassword2Field.text) {
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
      } else if (!regex.hasMatch(editEmailField.text)) {
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
              http.post(Constants.editURL, body: {
                "name": editUsernameField.text,
                "newemail": editEmailField.text,
                "email": HomePage.loggedEmail,
                "password": editPassword1Field.text,
                "profilepic": Constants.imagesFolderURL + imageName,
              }).then((res) {
                print(res.body);

                if (res.statusCode == 200) {
                  loginUsernameField.text = editUsernameField.text;
                  loginPasswordField.text = editPassword1Field.text;
                  HomePage.drawerProfilepic = Constants.imagesFolderURL + imageName;
                  HomePage.isLoggedin = true;
                  HomePage.loggedUsername = loginUsernameField.text;
                  HomePage.loggedEmail = editEmailField.text;
                  Navigator.pop(context);
                } else if (res.statusCode == 400) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Oh Snap! :(",
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
                  title: "Oh Snap! :(",
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
            http.post(Constants.editURL, body: {
              "name": editUsernameField.text,
              "newemail": editEmailField.text,
              "email": HomePage.loggedEmail,
              "password": editPassword1Field.text,
              "profilepic": Constants.defaultPic,
            }).then((res) {
              //  print(res.statusCode);

              if (res.statusCode == 200) {
                loginUsernameField.text = editUsernameField.text;
                loginPasswordField.text = editPassword1Field.text;
                HomePage.drawerProfilepic = Constants.defaultPic;
                HomePage.isLoggedin = true;
                HomePage.loggedUsername = loginUsernameField.text;
                HomePage.loggedEmail = editEmailField.text;
                Navigator.pop(context);
              } else if (res.statusCode == 400) {
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Oh Snap! :(",
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
                title: "Oh Snap! :(",
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

  Widget _decideProfilePic() {
    Size size = MediaQuery.of(context).size;
    if (_imageFile == null) {
      return CircleAvatar(
        backgroundColor: Colors.red[600],
        radius: size.width / 5.1,
        child: CircleAvatar(
          radius: size.width / 5.5,
          backgroundColor: Colors.red[600],
          backgroundImage: NetworkImage(HomePage.drawerProfilepic),
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

  _clearImage() async {
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
    String usernameText = editUsernameField.text;
    if (usernameText.length == 0) {
      usernameIcon = Icons.close;
      usernameColor = Colors.white.withOpacity(0);
      usernameTaken = false;
      return null;
    }
    if ((editUsernameField.text != '')) {
      http.post(Constants.checkUsernameURL, body: {
        "username": usernameText,
      }).then((res) {
        if (res.statusCode != 408) {
          //  print(res.body);
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
    String emailText = editEmailField.text;
    if (emailText.length == 0) {
      emailIcon = Icons.close;
      emailColor = Colors.white.withOpacity(0);
      emailTaken = false;
      return null;
    }
    if ((editEmailField.text != '')) {
      http.post(Constants.checkEmailURL, body: {
        "email": emailText,
      }).then((res) {
        if (res.statusCode != 408) {
          //  print(res.body);
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
          return null;
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
    if (editPassword1Field.text == editPassword2Field.text) {
      passwordIcon = Icons.check;
      confirmIcon = Icons.check;
      passwordColor = Colors.green.withOpacity(1);
      confirmColor = Colors.green.withOpacity(1);
    }
    if (editPassword1Field.text != editPassword2Field.text) {
      passwordIcon = Icons.check;
      confirmIcon = Icons.close;
      passwordColor = Colors.green.withOpacity(1);
      confirmColor = Colors.red.withOpacity(1);
    }
    if (editPassword1Field.text == '' || editPassword2Field.text == '') {
      passwordColor = Colors.green.withOpacity(0);
      confirmColor = Colors.green.withOpacity(0);
    }
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
                      _clearImage();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: _saveButton,
        backgroundColor: new Color(0xFFD73535),
        label: Text('Save'),
        icon: Icon(Icons.check),
      ),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: GradientAppBar(
            title: Text("Edit Profile"),
            centerTitle: true,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.red[800],
          )),
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
                  height: size.height - 250,
                  child: Column(children: <Widget>[
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        _showChoiceDialog(context);
                      },
                      child: _decideProfilePic(),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                        controller: editUsernameField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        onFieldSubmitted: (value) {
                          setState(() => validateUsername(value));
                        },
                        validator: (value) {
                          if (editUsernameField.text == '') {
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
                        controller: editEmailField,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        onFieldSubmitted: (value) {
                          setState(() => validateEmail(value));
                        },
                        validator: (value) {
                          if (editEmailField.text == '') {
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
                      controller: editPassword1Field,
                      style: TextStyle(color: Colors.blue[600], fontSize: 15),
                      //obscureText: to hide password chars for password text field.
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => validatePassword(value));
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(passwordIcon, color: passwordColor),
                          hintText: 'New Password',
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
                        controller: editPassword2Field,
                        style: TextStyle(color: Colors.blue[600], fontSize: 15),
                        //obscureText: to hide password chars fodr password text field.
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => validatePassword(value));
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm New Password',
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
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
