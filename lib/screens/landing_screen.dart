import 'package:flutter/material.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/screens/signup1.dart';

import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  static const String id = "landing_screen";
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.1, 0.6],
          colors: [kPrimaryBlue, Colors.white],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Image.asset('assets/logo/logo.png'),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                },
                                icon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ))),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text('Login',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: 1)))
                      ],
                    ),
                    SizedBox(width: 25.0),
                    SizedBox(
                      height: 40.0,
                      child: VerticalDivider(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 25.0),
                    Column(
                      children: <Widget>[
                        Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.popAndPushNamed(
                                      context, SignUpScreenOne.id);
                                },
                                icon: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ))),
                        SizedBox(
                          height: 7.0,
                        ),
                        Text('Sign Up',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    letterSpacing: 1)))
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
