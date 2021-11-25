import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/action_button.dart';
import 'package:vyaapaar/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = "forgot_password_screen";
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = "";

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
                        height: 40,
                      ),
                      Image.asset('assets/logo/vyaapaar_logo_white.png'),
                      Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration:
                              kInputDecotation.copyWith(hintText: 'Email ID')),
                      SizedBox(
                        height: 20,
                      ),
                      ActionButton(
                        color: Colors.white,
                        onPress: () {},
                        text: 'Submit',
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Divider(
                          color: Colors.white38,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, LoginScreen.id);
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
                            ))
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
