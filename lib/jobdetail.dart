import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_pickup/driver.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:my_pickup/job.dart';
import 'mainscreen.dart';
import 'package:geolocator/geolocator.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
String _currentAddress = "Searching your current location...";
class JobDetail extends StatefulWidget {
  final Job job;
  final Driver driver;
 

  const JobDetail({Key key, this.job, this.driver}) : super(key: key);

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddressFromLatLng();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.deepOrange));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('JOB DETAILS'),
            backgroundColor: Colors.deepOrange,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                job: widget.job,
                driver: widget.driver,
              ),
            ),
          )),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            driver: widget.driver,
          ),
        ));
    return Future.value(false);
  }

  _getAddressFromLatLng() async {
    try {
      String coordinates = widget.job.job_location;
      List<String> latLong = coordinates.split(",");
      double latitude = double.parse(latLong[0]);
      double longitude = double.parse(latLong[1]);


      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          latitude, longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }
}

class DetailInterface extends StatefulWidget {
  final Job job;
  final Driver driver;
  DetailInterface({this.job, this.driver});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
  }
 

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: <Widget>[
        Center(),
        Container(
          width: 280,
          height: 200,
         
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.job.job_name.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Job Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_desc),
                ]),
                TableRow(children: [
                  Text("Job Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_loc_names),
                ]),
                TableRow(children: [
                  Text("Job Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_location),
                ]),
                TableRow(children: [
                  Text("Job Destination",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_destination),
                ]),
                TableRow(children: [
                  Text("Customer",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_owner),
                ]),
                TableRow(children: [
                  Text("Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_date),
                ]),
                TableRow(children: [
                  Text("Rating",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.job.job_rating),
                ]),
                TableRow(children: [
                  Text("Address",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                 Text(_currentAddress),
                ]),
                

                
              ]),
              SizedBox(
                height: 10,
              ),
              
              Container(
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  height: 40,
                  child: Text(
                    'ACCEPT JOB',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptJob,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptJob() {
     if (widget.driver.email=="user@noregister"){
      Toast.show("Please register to view accept jobs", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else{
      _showDialog();
    }
    print("Accept Job");
    
  }

  void _showDialog() {
    // flutter defined function
    if (int.parse(widget.driver.credit)<1){
        Toast.show("Credit not enough ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Accept " + widget.job.job_id + " from " + widget.job.job_owner),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _getAddressFromLatLng() async {
    try {
      String coordinates = widget.job.job_location;
      List<String> latLong = coordinates.split(",");
      double latitude = double.parse(latLong[0]);
      double longitude = double.parse(latLong[1]);


      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          latitude, longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> acceptRequest() async {
    String urlLoadJobs = "http://pickupandlaundry.com/my_pickup/gifhary/acceptjobliang.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Job");
    pr.show();
    http.post(urlLoadJobs, body: {
      "job_id": widget.job.job_id,
      "email": widget.driver.email,
      "credit": widget.driver.credit,
      
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            _onLogin(widget.driver.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

   void _onLogin(String email, BuildContext ctx) {
     String urlgetuser = "http://pickupandlaundry.com/my_pickup/chan/php/getdriver.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        Driver driver = new Driver(
            name: dres[1],
            email: dres[2],
            phone: dres[3],
            credit: dres[4]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(driver: driver)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
