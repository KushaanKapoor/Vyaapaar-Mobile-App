import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/action_button.dart';
import 'package:vyaapaar/screens/dashboard.dart';
import 'package:vyaapaar/screens/forgot_password.dart';
import 'package:vyaapaar/screens/signup1.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static const id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";
  bool _showPassword = false;

  void _handleSignIn() async {
    try {
      // ignore: unused_local_variable
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.popAndPushNamed(context, Dashboard.id);
    } catch (e) {
      print(e.toString());
    }
  }

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
                        'LOGIN',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                        )),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Column(
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
                              kInputDecotation.copyWith(hintText: 'Email')),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w400)),
                          obscureText: !this._showPassword,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: kInputDecotation.copyWith(
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._showPassword
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() =>
                                    this._showPassword = !this._showPassword);
                              },
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                              color: Colors.blue[100],
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, ForgotPasswordScreen.id);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ActionButton(
                        color: Colors.white,
                        onPress: () {
                          _handleSignIn();
                        },
                        text: 'Login',
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
                              Navigator.pushNamed(context, SignUpScreenOne.id);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white38,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Sign Up",
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
