import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/screens/awarded_projects.dart';
import 'package:vyaapaar/screens/bid_on_projects.dart';
import 'package:vyaapaar/screens/create_project.dart';
import 'package:vyaapaar/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vyaapaar/screens/landing_screen.dart';
import 'package:vyaapaar/screens/my_projects.dart';
import 'package:vyaapaar/screens/my_bids_screen.dart';
import 'package:vyaapaar/screens/settings_menu.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MenuSideBar extends StatelessWidget {
  const MenuSideBar({
    Key key,
    @required Animation<Offset> slideAnimation,
    @required Animation<double> menuScaleAnimation,
  })  : _slideAnimation = slideAnimation,
        _menuScaleAnimation = menuScaleAnimation,
        super(key: key);

  final Animation<Offset> _slideAnimation;
  final Animation<double> _menuScaleAnimation;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: SizedBox(height: 1)),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(context, Dashboard.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.dashboard,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Dashboard",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ))),
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, BidOnProjects.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Bid on Projects",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ))),
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(context, MyBids.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Bid History",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, AwardedProjects.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.assistant_photo,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Awarded Projects",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, CreateProject.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.widgets,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Post a Project",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(context, MyProjects.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.view_list,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("My Projects",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onPressed: () {
                            Navigator.popAndPushNamed(context, SettingsMenu.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Settings",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                      Divider(
                        color: Colors.white60,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton(
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.popAndPushNamed(
                                context, LandingScreen.id);
                          },
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 40.0,
                            ),
                            SizedBox(width: 10.0),
                            Text("Logout",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                )))
                          ])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
