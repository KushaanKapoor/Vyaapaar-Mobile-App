import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/action_button.dart';
import 'package:vyaapaar/screens/dashboard.dart';
import 'package:vyaapaar/screens/login_screen.dart';
import 'package:vyaapaar/components/custom_dropdown.dart';
import 'package:vyaapaar/models/signupscreen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyaapaar/constants/data.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore firestoreInstance = Firestore.instance;

class SignUpScreenTwo extends StatefulWidget {
  static const id = "signup2";

  @override
  _SignUpScreenTwoState createState() => _SignUpScreenTwoState();
}

class _SignUpScreenTwoState extends State<SignUpScreenTwo> {
  SignUpScreen1Values args;
  String emailAddress;
  String password;
  String businessDomain;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      args = ModalRoute.of(context).settings.arguments;
    });
  }

  handleSignUp() async {
    try {
      final AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);
      Map<String, dynamic> userData = Map();
      userData['emailAddress'] = emailAddress;
      userData['businessDomain'] = businessDomain;
      userData['businessCity'] = args.businessCity;
      userData['businessName'] = args.businessName;
      userData['businessWebsite'] = args.businessWebsite;
      userData['registrationType'] = args.registrationType;
      userData["myProjects"] = [];
      userData["dateSignedUp"] = FieldValue.serverTimestamp();
      await firestoreInstance
          .collection("users")
          .document(authResult.user.uid)
          .setData(userData);

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
                              emailAddress = value;
                            });
                          },
                          decoration:
                              kInputDecotation.copyWith(hintText: 'Email ID')),
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
                      Text(
                        'Business Domain *:',
                        style: TextStyle(
                            color: Colors.blue[100],
                            decoration: TextDecoration.none),
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
                      ActionButton(
                          color: Colors.white,
                          onPress: () {
                            handleSignUp();
                          },
                          text: 'SignUp'),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        '2/2',
                        style: TextStyle(
                            color: Colors.blue[100],
                            decoration: TextDecoration.underline),
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
