import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_pickup/driver.dart';
import 'package:my_pickup/jobdetail.dart';
import 'package:my_pickup/job.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'SlideRightRoute.dart';

double perpage = 1;

class JobList extends StatefulWidget {
  final Driver driver;

  JobList({Key key, this.driver});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
   GlobalKey<RefreshIndicatorState> refreshKey;

  List data;

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    
  }

  @override
  Widget build(BuildContext context) {
    
   SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.teal));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
              
              body: RefreshIndicator(
              key: refreshKey,
              color: Colors.deepOrange,
              onRefresh: () async {
                await refreshList();
              },

              child:ListView.builder(
                  
                  itemCount: data == null ? 1 : data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                                Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10,10,10,5),
                                    height: MediaQuery.of(context).size.height/5,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.teal[50],
                  
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15,15,15,5),
                                  decoration: BoxDecoration(
                                  color: Colors.teal[100],
                                  border: Border.all(color: Colors.teal[300]),
                                  borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.teal[400],offset: Offset(0,0))]),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.person,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    widget.driver.name
                                                            .toUpperCase() ??
                                                        "Not registered",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.email,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.driver.email),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.phone,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.driver.phone),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.attach_money,
                                                    ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(widget.driver.credit),
                                                ),
                                              ],
                                            ),
                                            
                                            
                                            
                                          ],
                                        ),
                                  ),),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                                    color: Colors.teal[400],
                                    child: Center(
                                    child: Text("Job List Today",
                                    style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)
                                    ),),                            
                                    ),

                                    SizedBox(
                                      height: 4,
                                    ),

                                ],
                              ),
                      
                        ])
                      );
                    }                   
                    if (index == data.length && perpage > 1) {
                      return Container(
                        width: 250,
                        color: Colors.white,
                        child: MaterialButton(
                          child: Text(
                            "Load More",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {},
                        ),
                      );
                    }
                    index -= 1;
                    return Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: ()=> _onJobDetail(
                            data[index]['job_id'],
                            data[index]['job_name'],
                            data[index]['job_price'],
                            data[index]['job_desc'],
                            data[index]['job_loc_names'],
                            data[index]['job_location'],
                            data[index]['job_destination'],
                            data[index]['job_owner'],
                            data[index]['job_date'],
                            data[index]['driver_email'],
                            data[index]['job_rating'],
                            widget.driver.name,
                            widget.driver.credit,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                    'assets/images/gifhary@pickupandlaundry.com.jpg'
                                  )))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                            data[index]['job_name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text("Date " + data[index]['job_date']),
                                        
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
    )));
  }


  Future<String> makeRequest() async {
    String urlLoadJobs = "http://pickupandlaundry.com/my_pickup/gifhary/load_all_job_liang.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Jobs");
    pr.show();
    http.post(urlLoadJobs, body: {
      "email": widget.driver.email ?? "notavailable",
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        data = extractdata["jobs"];
        perpage = (data.length / 10);
        print("data");
        print(data);
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    return null;
  }

  Future init() async {
    this.makeRequest();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    this.makeRequest();
    return null;
  }

  void _onJobDetail(
      String job_id,
      String job_name,
      String job_price,
      String job_desc,
      String job_loc_names,
      String job_location,
      String job_destination,
      String job_owner,
      String job_date,
      String driver_email,
      String job_rating,
      String name,
      String credit) {
    Job job = new Job(
        job_id: job_id,
        job_name: job_name,
        job_price: job_price,
        job_desc: job_desc,
        job_loc_names: job_loc_names,
        job_location: job_location,
        job_destination: job_destination,
        job_owner: job_owner,
        job_date: job_date,
        driver_email: driver_email,
        job_rating: job_rating,
       );
    //print(data);
    
    Navigator.push(context, SlideRightRoute(page: JobDetail(job: job, driver: widget.driver)));
  }


  void _onJobDelete() {
    print("Delete");
  }

}
