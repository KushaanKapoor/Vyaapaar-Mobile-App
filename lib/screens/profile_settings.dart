import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:vyaapaar/constants/data.dart';
import 'package:vyaapaar/components/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;

class ProfileSettings extends StatefulWidget {
  static const String id = "Profile Settings";

  const ProfileSettings({
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
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  TextEditingController _nameController;
  TextEditingController _websiteController;
  TextEditingController _cityController;
  TextEditingController _emailController;

  Map<String, dynamic> currentUser;
  String businessName;
  String businessWebsite;
  String businessCity;
  String registrationType;
  String emailAddress;
  String businessDomain;
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
      //TODO: find id of current user and call getProfileDetails function with the id as its argument
    });
  }

  void getProfileDetails(String id) async {
    isLoading = true;

    try {
      final doc =
          await firestoreInstance.collection("users").document(id).get();

      setState(() {
        currentUser = doc.data;
        currentUser["id"] = doc.documentID;
        businessName = currentUser["businessName"];
        businessWebsite = currentUser["businessWebsite"];
        businessCity = currentUser["businessCity"];
        registrationType = currentUser["registrationType"];
        emailAddress = currentUser["emailAddress"];
        businessDomain = currentUser["businessDomain"];

        isLoading = false;
      });

      _nameController = TextEditingController(text: businessName);
      _websiteController = TextEditingController(text: businessWebsite);
      _cityController = TextEditingController(text: businessCity);
      _emailController = TextEditingController(text: emailAddress);
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

  void handleUpdateProfileDetails() async {
    try {
      //TODO: code of update profile goes here

      Fluttertoast.showToast(
          msg: "Project Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "There was some problem. Please try again.",
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
          width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: isLoading == true
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
                        Text(
                          'Business Name',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                            controller: _nameController,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                businessName = value;
                              });
                            },
                            decoration: kInputDecotation.copyWith(
                                hintText: 'Business Name *')),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Business Website',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                            controller: _websiteController,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.url,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                businessWebsite = value;
                              });
                            },
                            decoration: kInputDecotation.copyWith(
                                hintText: 'Business Website')),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Business City',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                            controller: _cityController,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                businessCity = value;
                              });
                            },
                            decoration: kInputDecotation.copyWith(
                                hintText: 'Business City')),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Registraction Type',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        CustomDropdown(
                            listOfStrings: registrationTypes,
                            value: registrationType,
                            setValue: (value) {
                              setState(() {
                                registrationType = value;
                              });
                            }),
                        Text(
                          'Email ID',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                            controller: _emailController,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              setState(() {
                                emailAddress = value;
                              });
                            },
                            decoration: kInputDecotation.copyWith(
                                hintText: 'Email ID')),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Business Domain',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        CustomDropdown(
                          listOfStrings: domains,
                          value: businessDomain,
                          setValue: (value) {
                            setState(() {
                              businessDomain = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ResizableActionButton(
                              isButtonDisabled: false,
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPress: () {
                                if (true /*TODO: check neccessary conditions here*/) {
                                  handleUpdateProfileDetails();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black12,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              text: 'Update',
                              width: 150,
                            ),
                            ResizableActionButton(
                              isButtonDisabled: false,
                              color: Colors.black87,
                              textColor: Colors.white,
                              onPress: () {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              width: 100,
                            ),
                          ],
                        )
                      ],
              ),
            ),
          )),
    );
  }
}
