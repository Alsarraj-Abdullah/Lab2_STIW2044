import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:helloworld/SignInPage.dart';
import 'package:helloworld/EditProfile.dart';
import 'package:helloworld/SignupPage.dart';
import 'package:helloworld/payment.dart';
import 'UnicornOutlineButton.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:helloworld/Barber.dart';
import 'constants.dart' as Constants;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

String _value;

class HomePage extends StatefulWidget {
  static String loggedUsername = 'Not signed in.';
  static String loggedEmail = "";
  static String signinButtonText = 'Sign In';
  static String drawerProfilepic =
      'https://sharpns.net/mybarber3/images/profilepic.png';
  static bool isLoggedin = false;
  static int loggedBalance = 0;
  static double sliderHeight = 295;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this._getBarbers();
    this._updateUserData();
    return null;
  }

  Future init() async {
    this._getBarbers();
    this._updateUserData();
    //_getCurrentLocation();
  }

  void _updateUserData() {
    if(HomePage.isLoggedin==true){
http.get(Constants.getUserDataURL + HomePage.loggedUsername).then((res) {
      var jsonData = json.decode(res.body);
      var ppic = jsonData['Profile_pic'];
      var balance = jsonData['Balance'];
      var email = jsonData['Email'];
      setState(() {
        HomePage.drawerProfilepic = ppic;
        HomePage.loggedBalance = int.parse(balance);
        HomePage.loggedEmail = email;
      });
    }).catchError((err) {
      print(err);
    });
    }else{
            setState(() {
        HomePage.drawerProfilepic = Constants.defaultPic;
        HomePage.loggedBalance = 0;
        HomePage.loggedEmail = "";
      });
    }
  }

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
    _updateUserData();
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
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.redAccent,
        onRefresh: () async {
          await refreshList();
        },
        child: Stack(
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
                                            image: NetworkImage(snapshot
                                                .data[index].profilepic),
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
                                              color: Colors.grey[600],
                                              size: 20),
                                          SizedBox(width: 5),
                                          Flexible(

                                              //We only want to wrap the text message with flexible widget
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Text(
                                                    snapshot.data[index]
                                                        .phonenumber,
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
                                              color: Colors.grey[600],
                                              size: 23),
                                          SizedBox(width: 5),
                                          Flexible(

                                              //We only want to wrap the text message with flexible widget
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Text(
                                                    snapshot
                                                        .data[index].address,
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
                                          Image.asset(
                                            'cr_blue.png',
                                            height: 18,
                                            width: 18,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(

                                              //We only want to wrap the text message with flexible widget
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Text(
                                                    int.parse(snapshot
                                                                .data[index]
                                                                .price)
                                                            .toString() +
                                                        ' Credits',
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
                height: HomePage.sliderHeight,
                child: DrawerHeader(
                  child: ListView(children: <Widget>[
                    GestureDetector(
                      onTap: () {
if(HomePage.isLoggedin==true ){
  print(HomePage.isLoggedin);
Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                            );
}
                      },
                      child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: size.width / 9,
                      child: CircleAvatar(
                        radius: size.width / 10,
                        backgroundColor: Colors.cyan,
                        backgroundImage:
                            NetworkImage(HomePage.drawerProfilepic),
                      ),
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
                          ' Balance: ' +
                              int.parse(HomePage.loggedBalance.toString())
                                  .toString() +
                              ' Credits',
                          maxLines: 5,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(height: 13),
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
                              HomePage.loggedEmail = '';
                              HomePage.loggedBalance = 0;

                              HomePage.signinButtonText = 'Sign In';
                              HomePage.sliderHeight = 295;
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
                    SizedBox(height: 10),
                    new SizedBox(
                      height: size.height / 28,
                      width: size.width / 28,
                      child: UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 24,
                        gradient: LinearGradient(
                            colors: [Colors.cyan[50], Colors.cyan[600]]),
                        child: Text('Buy Credits',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () {
                          if (HomePage.isLoggedin == true) {
                            Alert(
                              image: Image.asset("cr_tower.png",
                                  height: 150, width: 150),
                              context: context,
                              //  type: AlertType.info,
                              title: "Credits Reload",
                              desc:
                                  "Choose Credits Amount from the List below:",
                              content: Column(children: <Widget>[
                                SizedBox(height: 20),
                                DropdownExample()
                              ]),
                              buttons: [
                                DialogButton(
                                  color: Colors.green[400],
                                  child: Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    if (_value != null) {
                                      Navigator.of(context).pop();
                                      var now = new DateTime.now();
                                      var formatter =
                                          new DateFormat('ddMMyyyyhhmmss-');
                                      String formatted = formatter.format(now) +
                                          randomAlphaNumeric(10);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentScreen(
                                                      orderid: formatted,
                                                      val: _value)));
                                    }
                                  },
                                  width: 220,
                                )
                              ],
                            ).show();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    new SizedBox(
                      height: size.height / 28,
                      width: size.width / 28,
                      child: UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 24,
                        gradient: LinearGradient(
                            colors: [Colors.cyan[50], Colors.cyan[600]]),
                        child: Text('Edit Profile',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                            );
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

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Row(
              children: <Widget>[
                Text(
                  '100 ',
                  style: TextStyle(
                      color: Color.fromRGBO(235, 202, 52, 1),
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          color: Color.fromRGBO(120, 100, 23, 1),
                        )
                      ]),
                ),
                Image.asset(
                  'cr.png',
                  height: 17,
                  width: 17,
                ),
                Text(
                  ' (10 RM)',
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w700),
                )
              ],
            ),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Row(
              children: <Widget>[
                Text(
                  '200 ',
                  style: TextStyle(
                      color: Color.fromRGBO(235, 202, 52, 1),
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          color: Color.fromRGBO(120, 100, 23, 1),
                        )
                      ]),
                ),
                Image.asset(
                  'cr.png',
                  height: 17,
                  width: 17,
                ),
                Text(
                  ' (20 RM)',
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w700),
                )
              ],
            ),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Row(
              children: <Widget>[
                Text(
                  '300 ',
                  style: TextStyle(
                      color: Color.fromRGBO(235, 202, 52, 1),
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          color: Color.fromRGBO(120, 100, 23, 1),
                        )
                      ]),
                ),
                Image.asset(
                  'cr.png',
                  height: 17,
                  width: 17,
                ),
                Text(
                  ' (30 RM)',
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w700),
                )
              ],
            ),
            value: '30',
          ),
          DropdownMenuItem<String>(
            child: Row(
              children: <Widget>[
                Text(
                  '500 ',
                  style: TextStyle(
                      color: Color.fromRGBO(235, 202, 52, 1),
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          color: Color.fromRGBO(120, 100, 23, 1),
                        )
                      ]),
                ),
                Image.asset(
                  'cr.png',
                  height: 17,
                  width: 17,
                ),
                Text(
                  ' (50 RM)',
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w700),
                )
              ],
            ),
            value: '50',
          ),
          DropdownMenuItem<String>(
            child: Row(
              children: <Widget>[
                Text(
                  '1000 ',
                  style: TextStyle(
                      color: Color.fromRGBO(235, 202, 52, 1),
                      fontWeight: FontWeight.w700,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          color: Color.fromRGBO(120, 100, 23, 1),
                        )
                      ]),
                ),
                Image.asset(
                  'cr.png',
                  height: 17,
                  width: 17,
                ),
                Text(
                  ' (100 RM)',
                  style: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.w700),
                )
              ],
            ),
            value: '100',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Amount'),
        value: _value,
      ),
    );
  }
}
