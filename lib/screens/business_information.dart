import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;

class BusinessInformation extends StatefulWidget {
  static const String id = "Business Information";

  const BusinessInformation({
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
  _BusinessInformationState createState() => _BusinessInformationState();
}

class _BusinessInformationState extends State<BusinessInformation> {
  Map<String, dynamic> businessDetails;
  bool isLoading;

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

    Future.delayed(Duration.zero, () {
      businessDetails = ModalRoute.of(context).settings.arguments;
      print(businessDetails);
      getBusinessDetails(businessDetails["uid"]);
    });
  }

  Future<void> getBusinessDetails(String uid) async {
    isLoading = true;
    try {
      DocumentSnapshot userDoc =
          await firestoreInstance.collection("users").document(uid).get();

      setState(() {
        businessDetails = userDoc.data;
        businessDetails["uid"] = uid;
        isLoading = false;
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        SizedBox(height: 10.0),
                        Text(
                          'Business Name',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${businessDetails["businessName"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Website',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${businessDetails["businessWebsite"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Email Address',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${businessDetails["emailAddress"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Business City',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${businessDetails["businessCity"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Registration Type',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${businessDetails["registrationType"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                      ],
              ),
            ),
          )),
    );
  }
}
