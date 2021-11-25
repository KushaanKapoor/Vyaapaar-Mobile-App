import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/components/reusable_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:cloud_firestore/cloud_firestore.dart";
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:charts_flutter/flutter.dart' as charts;
final Firestore firestoreInstance = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Dashboard extends StatefulWidget {
  static const String id = "Dashboard";

  //TODO: uncomment charts and see what the error is

  const Dashboard({
    Key key,
    @required this.duration,
    @required this.isCollapsed,
    @required this.screenWidth,
    @required Animation<double> scaleAnimation,
    @required AnimationController controller,
    @required this.isCollaped,
    @required this.setIsCollaped,
  })  : _scaleAnimation = scaleAnimation,
        _controller = controller,
        super(key: key);

  final Duration duration;
  final bool isCollapsed;
  final double screenWidth;
  // ignore: unused_field
  final Animation<double> _scaleAnimation;
  final AnimationController _controller;
  final bool isCollaped;
  final Function setIsCollaped;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = false;
  var userData;
  var noOfBids;
  var noOfAwardedBids;
  var noOfProjectsAwarded;
  var noOfMyProjects;
  var noOfTotalProjects;
  List projects = [];

  void toggleSidebar() {
    if (widget.isCollapsed)
      openSidebar();
    else
      closeSidebar();
  }

  void openSidebar() {
    widget._controller.forward();
    widget.setIsCollaped(false);
  }

  void closeSidebar() {
    widget._controller.reverse();
    widget.setIsCollaped(true);
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    getMyProjects();
  }

  Future<void> getDetails() async {
    isLoading = true;

    try {
      final user = await _auth.currentUser();
      final userDetails =
          await firestoreInstance.collection("users").document(user.uid).get();
      final QuerySnapshot userBids = await firestoreInstance
          .collection("users")
          .document(user.uid)
          .collection("bids")
          .getDocuments();

      int count = 0;
      for (int i = 0; i < userBids.documents.length; i++) {
        print("awarded");
        print(userBids.documents[i]['isAwarded']);
        if (userBids.documents[i]['isAwarded'] == true) {
          print("yaay");
          count = count + 1;
        }
      }
      // print(userBids.documents.length);
      // print(userDetails["myProjects"].length);
      setState(() {
        isLoading = false;
        userData = userDetails;
        noOfTotalProjects = userDetails["myProjects"] != null
            ? userDetails["myProjects"].length + count
            : 0;
        noOfBids = userBids.documents.length;
        noOfAwardedBids = count;
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Check you Network Connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> getMyProjects() async {
    isLoading = true;
    int count = 0;
    try {
      final user = await _auth.currentUser();
      final userDetails =
          await firestoreInstance.collection("users").document(user.uid).get();
      final projectIDs = userDetails.data["myProjects"];
      projects.clear();
      for (int i = 0; i < projectIDs.length; i++) {
        // ignore: non_constant_identifier_names
        String p_id = projectIDs[i];
        final doc =
            await firestoreInstance.collection("projects").document(p_id).get();
        // ignore: non_constant_identifier_names
        print(doc.data);
        if (doc.data["isAwarded"] == true) {
          // ignore: non_constant_identifier_names
          count = count + 1;
        }
      }
      setState(() {
        isLoading = false;
        noOfProjectsAwarded = count;
      });
    } catch (e) {
      print('error' + e.toString());
      Fluttertoast.showToast(
          msg: "Check you Network Connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  /*
  Map<String, int> projectsToDisplay = {
    "Jan" : 2,
    "Feb" : 3,
    "Mar" : 6,
    "Apr" : 3,
    "May" : 0,
    "Jun" : 1,
    "Jul" : 0,
    "Aug" : 2,
    "Sep" : 0,
    "Oct" : 2,
    "Nov" : 0,
    "Dec" : 0
  };

  List<charts.Series<MyProjects, String>> _createSampleData() {
    final List<MyProjects> data = List<MyProjects>();

    projectsToDisplay.forEach((key, value) {
      data.add(MyProjects(key, value));
    });

    return [
      new charts.Series<MyProjects, String>(
          id: 'Sales',
          domainFn: (MyProjects object, _) => object.month,
          measureFn: (MyProjects object, _) => object.count,
          data: data,
          labelAccessorFn: (MyProjects object, _) => '${object.count}')
    ];
  }

  static List<charts.Series<LinearSales, int>> _createSampleDataForDonutChart() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
  */

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
          decoration: BoxDecoration(
              color: Color(0xFFE8E9EB),
              borderRadius: !widget.isCollapsed
                  ? BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
          child: SingleChildScrollView(
            physics: widget.isCollapsed ? null : NeverScrollableScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: isLoading
                    ? <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 60.0,
                            width: 60.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                              value: null,
                              strokeWidth: 4.0,
                            ),
                          ),
                        ),
                      ]
                    : <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Namaste, ${userData['businessName']}',
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w700)))),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Column(
                            children: <Widget>[
                              Text(
                                  '" Wo insaan jo dusaro ki nakal karta hai thode time ke liye safal ho sakta hai but jiwan me bahut aage nahi badh sakta "',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                  ))),
                              SizedBox(
                                height: 5,
                              ),
                              Text('- Ratan Tata',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                  ))),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Text('Analytics',
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w900)))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ReusableCard(
                                    length: 150,
                                    textLine1: "Total",
                                    textLine2: "Projects",
                                    numericalValue: noOfTotalProjects,
                                    fontSize: 20)),
                            // Padding(
                            //     padding: const EdgeInsets.only(top: 15.0),
                            //     child: ReusableCard(
                            //         length: 150,
                            //         textLine1: "Active",
                            //         textLine2: "Projects",
                            //         numericalValue: 10,
                            //         fontSize: 20)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ReusableCard(
                                    length: 150,
                                    textLine1: "Projects",
                                    textLine2: "Awarded",
                                    numericalValue: noOfProjectsAwarded,
                                    fontSize: 20)),
                            // Padding(
                            //     padding: const EdgeInsets.only(top: 15.0),
                            //     child: ReusableCard(
                            //         length: 150,
                            //         textLine1: "Projects",
                            //         textLine2: "Completed",
                            //         numericalValue: 10,
                            //         fontSize: 20)),
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ReusableCard(
                                    length: 150,
                                    textLine1: "Bids",
                                    textLine2: "Awarded",
                                    numericalValue: noOfAwardedBids,
                                    fontSize: 20)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ReusableCard(
                                    length: 150,
                                    textLine1: "Bids",
                                    textLine2: "Placed",
                                    numericalValue:
                                        noOfBids != null ? noOfBids : 0,
                                    fontSize: 20)),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: ReusableCard(
                                length: 250,
                                textLine1: "My",
                                textLine2: "Projects",
                                numericalValue: userData["myProjects"] != null
                                    ? userData["myProjects"].length
                                    : 0,
                                fontSize: 30)),
                        /*Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: charts.BarChart(
                                      _createSampleData(),
                                      animate: true,
                                      vertical: true,
                                      // Set a bar label decorator.
                                      // Example configuring different styles for inside/outside:
                                      //       barRendererDecorator: new charts.BarLabelDecorator(
                                      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
                                      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
                                      barRendererDecorator:
                                          charts.BarLabelDecorator<String>(),
                                      // Hide domain axis.
                                      domainAxis: new charts.OrdinalAxisSpec(
                                          renderSpec: new charts.NoneRenderSpec()),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: charts.PieChart(
                                        _createSampleDataForDonutChart(),
                                        animate: true,
                                        // Configure the width of the pie slices to 60px. The remaining space in
                                        // the chart will be left as a hole in the center.
                                        defaultRenderer: new charts.ArcRendererConfig(arcWidth: 30))
                                    ),*/
                      ],
              ),
            ),
          )),
    );
  }
}
/*
class MyProjects {
  final String month;
  final int count;
  MyProjects(this.month, this.count);
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
*/
