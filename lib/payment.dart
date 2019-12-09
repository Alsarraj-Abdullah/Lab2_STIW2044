import 'dart:async';
import 'package:helloworld/HomePage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final String orderid, val;
  PaymentScreen({this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  void initState() {
    // print('Init: $_loginUsername');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Payment'),
              backgroundColor: Colors.redAccent[700],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: WebView(
                    initialUrl:
                        'https://sharpns.net/mybarber3/php/payment/payment.php?email=' +
                            HomePage.loggedEmail +
                            '&name=' +
                            HomePage.loggedUsername +
                            '&amount=' +
                            widget.val +
                            '&orderid=' +
                            widget.orderid,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                  ),
                )
              ],
            )));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    return Future.value(false);
  }
}
