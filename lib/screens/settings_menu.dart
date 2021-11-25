import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/screens/password_settings.dart';
import 'package:vyaapaar/screens/profile_settings.dart';

class SettingsMenu extends StatefulWidget {
  static const String id = "Settings";

  const SettingsMenu({
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
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pushNamed(context, ProfileSettings.id);
                      },
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Colors.black87,
                          size: 40.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("Profile",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ))),
                      ])),
                  Divider(
                    color: Colors.black54,
                  ),
                  FlatButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pushNamed(context, PasswordSettings.id);
                      },
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.security,
                          color: Colors.black87,
                          size: 40.0,
                        ),
                        SizedBox(width: 10.0),
                        Text("Security",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ))),
                      ])),
                  Divider(
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
