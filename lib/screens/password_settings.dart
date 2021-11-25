import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class PasswordSettings extends StatefulWidget {
  static const String id = "Password Settings";

  const PasswordSettings({
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
  _PasswordSettingsState createState() => _PasswordSettingsState();
}

class _PasswordSettingsState extends State<PasswordSettings> {
  String currentPassword;
  String newPassword;
  String confirmNewPassword;
  bool _showPasswordFeild1 = false;
  bool _showPasswordFeild2 = false;
  bool _showPasswordFeild3 = false;

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
  }

  void handleUpdatePasswordDetails() async {
    try {
      FirebaseUser user = await _auth.currentUser();

      AuthCredential credential = EmailAuthProvider.getCredential(
          email: user.email, password: currentPassword);
      AuthResult result;
      bool isCorrectPassword = false;
      try {
        result = await user.reauthenticateWithCredential(credential);
        isCorrectPassword = true;
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Current Password is Incorrect",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black12,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      if (isCorrectPassword) {
        print(result.user);
        await user.updatePassword(newPassword);
        Fluttertoast.showToast(
            msg: "Password Updated Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black12,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
      }
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
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 15),
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
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'Current Password',
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
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400)),
                      obscureText: !this._showPasswordFeild1,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          currentPassword = value;
                        });
                      },
                      decoration: kInputDecotation.copyWith(
                        hintText: 'Enter Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showPasswordFeild1
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => this._showPasswordFeild1 =
                                !this._showPasswordFeild1);
                          },
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'New Password',
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
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400)),
                      obscureText: !this._showPasswordFeild2,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          newPassword = value;
                        });
                      },
                      decoration: kInputDecotation.copyWith(
                        hintText: 'Enter New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showPasswordFeild2
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => this._showPasswordFeild2 =
                                !this._showPasswordFeild2);
                          },
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400)),
                      obscureText: !this._showPasswordFeild3,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          confirmNewPassword = value;
                        });
                      },
                      decoration: kInputDecotation.copyWith(
                        hintText: 'Enter New Password Again',
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showPasswordFeild3
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() => this._showPasswordFeild3 =
                                !this._showPasswordFeild3);
                          },
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ResizableActionButton(
                        isButtonDisabled: false,
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPress: () {
                          if (newPassword == confirmNewPassword) {
                            handleUpdatePasswordDetails();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Both New Passwords Must Match",
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
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
