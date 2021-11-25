import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:vyaapaar/screens/login_screen.dart';
import 'package:vyaapaar/screens/signup2.dart';
import 'package:vyaapaar/components/custom_dropdown.dart';
import 'package:vyaapaar/models/signupscreen1.dart';
import 'package:vyaapaar/constants/data.dart';

class SignUpScreenOne extends StatefulWidget {
  static const id = "signup1";

  @override
  _SignUpScreenOneState createState() => _SignUpScreenOneState();
}

class _SignUpScreenOneState extends State<SignUpScreenOne> {
  String businessName;
  String businessWebsite;
  String businessCity;
  String registrationType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.1, 0.4],
          colors: [kPrimaryBlue, kSecondaryBlue],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset('assets/logo/vyaapaar_logo_white.png'),
                      Column(
                        children: <Widget>[
                          Text(
                            'Create Account',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 35.0)),
                          ),
                          Text('Enter your Details',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 20.0)))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    children: <Widget>[
                      TextField(
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
                      TextField(
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
                      TextField(
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
                        'Registration Type *:',
                        style: TextStyle(
                            color: Colors.blue[100],
                            decoration: TextDecoration.none),
                      ),
                      CustomDropdown(
                          listOfStrings: registrationTypes,
                          value: registrationType,
                          setValue: (value) {
                            setState(() {
                              registrationType = value;
                            });
                          }),
                      ResizableActionButton(
                        isButtonDisabled: false,
                        textColor: Colors.blueGrey,
                        color: Colors.white,
                        onPress: () {
                          Navigator.pushNamed(context, SignUpScreenTwo.id,
                              arguments: SignUpScreen1Values(
                                  businessCity: businessCity,
                                  businessName: businessName,
                                  businessWebsite: businessWebsite,
                                  registrationType: registrationType));
                        },
                        text: 'Next',
                        width: 100,
                      ),
                      Text(
                        '1/2',
                        style: TextStyle(
                            color: Colors.blue[100],
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Divider(
                          color: Colors.white38,
                        ),
                        GestureDetector(
                            onTap: () {
                              try {
                                Navigator.pushNamed(context, LoginScreen.id,
                                    arguments: {
                                      businessName: this.businessName,
                                      businessWebsite: this.businessWebsite,
                                      businessCity: this.businessCity,
                                      registrationType: this.registrationType
                                    });
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.lock_outline,
                                  color: Colors.white38,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white60),
                                ),
                              ],
                            )),
                        SizedBox(height: 20.0)
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
