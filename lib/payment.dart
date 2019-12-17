import 'dart:async';
import 'package:my_pickup/driver.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class PaymentScreen extends StatefulWidget {

  final Driver driver;
  final String orderid,val;
  PaymentScreen({this.driver,this.orderid,this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
    Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
 Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        appBar: AppBar(
            title: Text('PAYMENT'),
            backgroundColor: Colors.deepOrange,
          ),
      body: Column(children: <Widget>[
        Expanded(child:  WebView(
        initialUrl: 'http://pickupandlaundry.com/my_pickup/chan/php/payment.php?email='+widget.driver.email+'&mobile='+widget.driver.phone+'&name='+widget.driver.name+'&amount='+widget.val+'&orderid='+widget.orderid,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),)
      ],)
    ));
  }


  Future<bool> _onBackPressAppBar() async {
    print("onbackpress payment");
    String urlgetuser = "http://pickupandlaundry.com/my_pickup/chan/php/getdriver.php";

    http.post(urlgetuser, body: {
      "email": widget.driver.email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Driver updatedriver = new Driver(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            credit: dres[4],
            );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen(driver: updatedriver)));
      }
    }).catchError((err) {
      print(err);
    });
    return Future.value(false);
  }
}