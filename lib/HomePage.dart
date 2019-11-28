import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:helloworld/SignInPage.dart';
import 'package:helloworld/SignupPage.dart';
import 'UnicornOutlineButton.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:helloworld/Barber.dart';
import 'constants.dart' as Constants;

class HomePage extends StatefulWidget {
  static String loggedUsername = 'Not signed in.';
  static String signinButtonText = 'Sign In';
  static String drawerProfilepic =
      'https://sharpns.net/mybarber3/images/profilepic.png';
  static bool isLoggedin = false;
  static var loggedBalance = 0;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Barber>> _getBarbers() async {
    var data = await http.get(Constants.loadBarbersURL);
    var jsonData = json.decode(data.body);
    var jsonData2 = jsonData['Barbers'];

    List<Barber> barbers = [];

    for (var u in jsonData2) {
      Barber account = Barber(u["Name"], u["Phone_Number"], u["Price"],
          u["Address"], u["Profile_pic"]);

      barbers.add(account);
    }

    return barbers;
  }

  Widget build(BuildContext context) {
//Signup text URL Launcher.

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: GradientAppBar(
            title: Image.asset('logotext.png',
                alignment: Alignment.centerLeft, fit: BoxFit.fill),
            centerTitle: true,
            backgroundColorStart: Colors.redAccent,
            backgroundColorEnd: Colors.red[800],
          )),
      body: Stack(
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
          FutureBuilder(
            future: _getBarbers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                    child: Center(
                        child: SpinKitRipple(
                  color: Colors.red[600],
                  size: 150.0,
                )));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          //on card click
                        },
                        child: Card(
//                color: Colors.blue,

                          elevation: 4,

                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data[index].profilepic),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(75.0)),
                                      border: Border.all(
                                          width: 3,
                                          color: Colors.red[600],
                                          style: BorderStyle.solid)),
                                ),
                              ),
                              new Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.content_cut,
                                            color: Colors.red[600], size: 20),
                                        SizedBox(width: 5),
                                        Flexible(

                                            //We only want to wrap the text message with flexible widget
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red[600],
                                                      fontSize: 18),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                      ]),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.phone,
                                            color: Colors.grey[600], size: 20),
                                        SizedBox(width: 5),
                                        Flexible(

                                            //We only want to wrap the text message with flexible widget
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  snapshot
                                                      .data[index].phonenumber,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 16),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))),
                                      ]),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.location_on,
                                            color: Colors.grey[600], size: 23),
                                        SizedBox(width: 5),
                                        Flexible(

                                            //We only want to wrap the text message with flexible widget
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  snapshot.data[index].address,
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14),
                                                ))),
                                      ]),
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.attach_money,
                                            color: Colors.blue[600], size: 22),
                                        SizedBox(width: 5),
                                        Flexible(

                                            //We only want to wrap the text message with flexible widget
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: Text(
                                                  double.parse(snapshot
                                                              .data[index]
                                                              .price)
                                                          .toString() +
                                                      ' RM',
                                                  maxLines: 5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue[600],
                                                      fontSize: 15),
                                                ))),
                                      ]),
                                ],
                              )),
                            ],
                          ),
                        ));
                  },
                );
              }
            },
          )
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                height: 300,
                child: DrawerHeader(
                  child: ListView(children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: size.width / 9,
                      child: CircleAvatar(
                        radius: size.width / 10,
                        backgroundColor: Colors.cyan,
                        backgroundImage:
                            NetworkImage(HomePage.drawerProfilepic),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      HomePage.loggedUsername,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          'Balance: ' +
                              double.parse(HomePage.loggedBalance.toString())
                                  .toString() +
                              ' RM',
                          maxLines: 5,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    new SizedBox(
                      height: size.height / 28,
                      width: size.width / 28,
                      child: UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 24,
                        gradient: LinearGradient(
                            colors: [Colors.cyan[50], Colors.cyan[600]]),
                        child: Text(HomePage.signinButtonText,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () {
                          if (HomePage.isLoggedin == true) {
                            setState(() {
                              HomePage.drawerProfilepic =
                                  'https://sharpns.net/mybarber3/images/profilepic.png';
                              HomePage.loggedBalance = 0;
                              HomePage.loggedUsername = 'Not signed in.';
                              HomePage.isLoggedin = false;
                              HomePage.signinButtonText = 'Sign In';
                            });
                          } else if (HomePage.isLoggedin == false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SigninPage()),
                            );
                          }
                        },
                      ),
                    ),
                  ]),
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.cyan[500], Colors.indigo],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                )),
            ListTile(
              leading: Icon(Icons.content_cut, color: Colors.grey),
              title: Text('Browse Barbers'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.grey),
              title: Text('Sign Up'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.grey),
              title: Text('Help'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.grey),
              title: Text('About Us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Barber barber;

  DetailPage(this.barber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(barber.name),
    ));
  }
}
