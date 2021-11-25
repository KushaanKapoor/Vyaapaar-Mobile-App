import 'package:flutter/material.dart';
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/components/menu.dart';
import 'package:vyaapaar/screens/bid_detail_screen.dart';
import 'package:vyaapaar/screens/bid_on_projects.dart';
import 'package:vyaapaar/screens/business_information.dart';
import 'package:vyaapaar/screens/my_projects.dart';
import 'package:vyaapaar/screens/awarded_projects.dart';
import 'package:vyaapaar/screens/create_project.dart';
import 'package:vyaapaar/screens/dashboard.dart';
import 'package:vyaapaar/screens/password_settings.dart';
import 'package:vyaapaar/screens/profile_screen.dart';
import 'package:vyaapaar/screens/settings_menu.dart';
import 'package:vyaapaar/screens/view_detail_all_projects.dart';
import 'package:vyaapaar/screens/view_detail_my_projects.dart';
import 'package:vyaapaar/screens/edit_project.dart';
import 'package:vyaapaar/screens/show_bids.dart';
import 'package:vyaapaar/screens/view_detail_awarded_project.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/screens/my_bids_screen.dart';
import 'package:vyaapaar/screens/view_detail_bidded_project.dart';
import 'package:vyaapaar/screens/profile_settings.dart';

final Color backgroundColor = Color(0xFF4A4A58);

class MainScreen extends StatefulWidget {
  static const String id = "main_screen";
  final String alterScreen;
  MainScreen(this.alterScreen);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setIsCollaped(newValue) {
    setState(() {
      isCollapsed = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              MenuSideBar(
                  slideAnimation: _slideAnimation,
                  menuScaleAnimation: _menuScaleAnimation),
              AnimatedPositioned(
                duration: duration,
                top: 0,
                bottom: 0,
                left: isCollapsed ? 0 : 0.6 * screenWidth,
                right: isCollapsed ? 0 : -0.2 * screenWidth,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Material(
                    animationDuration: duration,
                    borderRadius: !isCollapsed
                        ? BorderRadius.all(Radius.circular(40))
                        : null,
                    elevation: 8,
                    color: Colors.white,
                    child: Stack(
                      overflow: Overflow.clip,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 25, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    child: Icon(Icons.menu,
                                        color: Colors.blueAccent),
                                    onTap: () {
                                      setState(() {
                                        if (isCollapsed)
                                          _controller.forward();
                                        else
                                          _controller.reverse();

                                        setIsCollaped(!isCollapsed);
                                      });
                                    },
                                  ),
                                  Text(widget.alterScreen.toString(),
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w700))),
                                  [ProfileScreen.id]
                                          .contains(widget.alterScreen)
                                      ? null
                                      : InkWell(
                                          child: Icon(Icons.account_circle,
                                              color: Colors.blueAccent),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, ProfileScreen.id);
                                          },
                                        ),
                                ].where((elem) => elem != null).toList(),
                              ),
                            ),
                            widget.alterScreen == Dashboard.id
                                ? Dashboard(
                                    duration: duration,
                                    isCollapsed: isCollapsed,
                                    screenWidth: screenWidth,
                                    scaleAnimation: _scaleAnimation,
                                    controller: _controller,
                                    isCollaped: isCollapsed,
                                    setIsCollaped: setIsCollaped)
                                : widget.alterScreen == CreateProject.id
                                    ? CreateProject(
                                        duration: duration,
                                        isCollapsed: isCollapsed,
                                        screenWidth: screenWidth,
                                        scaleAnimation: _scaleAnimation,
                                        controller: _controller,
                                        isCollaped: isCollapsed,
                                        setIsCollaped: setIsCollaped)
                                    : widget.alterScreen == BidOnProjects.id
                                        ? BidOnProjects(
                                            duration: duration,
                                            isCollapsed: isCollapsed,
                                            screenWidth: screenWidth,
                                            scaleAnimation: _scaleAnimation,
                                            controller: _controller,
                                            isCollaped: isCollapsed,
                                            setIsCollaped: setIsCollaped)
                                        : widget.alterScreen == MyProjects.id
                                            ? MyProjects(
                                                duration: duration,
                                                isCollapsed: isCollapsed,
                                                screenWidth: screenWidth,
                                                scaleAnimation: _scaleAnimation,
                                                controller: _controller,
                                                isCollaped: isCollapsed,
                                                setIsCollaped: setIsCollaped)
                                            : widget.alterScreen == AwardedProjects.id
                                                ? AwardedProjects(
                                                    duration: duration,
                                                    isCollapsed: isCollapsed,
                                                    screenWidth: screenWidth,
                                                    scaleAnimation:
                                                        _scaleAnimation,
                                                    controller: _controller,
                                                    isCollaped: isCollapsed,
                                                    setIsCollaped:
                                                        setIsCollaped)
                                                : widget.alterScreen ==
                                                        ViewDetailAllProject.id
                                                    ? ViewDetailAllProject(
                                                        duration: duration,
                                                        isCollapsed:
                                                            isCollapsed,
                                                        screenWidth:
                                                            screenWidth,
                                                        scaleAnimation:
                                                            _scaleAnimation,
                                                        controller: _controller,
                                                        isCollaped: isCollapsed,
                                                        setIsCollaped:
                                                            setIsCollaped)
                                                    : widget.alterScreen ==
                                                            ViewDetailMyProject
                                                                .id
                                                        ? ViewDetailMyProject(
                                                            duration: duration,
                                                            isCollapsed:
                                                                isCollapsed,
                                                            screenWidth:
                                                                screenWidth,
                                                            scaleAnimation:
                                                                _scaleAnimation,
                                                            controller:
                                                                _controller,
                                                            isCollaped:
                                                                isCollapsed,
                                                            setIsCollaped:
                                                                setIsCollaped)
                                                        : widget.alterScreen ==
                                                                EditProject.id
                                                            ? EditProject(
                                                                duration:
                                                                    duration,
                                                                isCollapsed:
                                                                    isCollapsed,
                                                                screenWidth:
                                                                    screenWidth,
                                                                scaleAnimation:
                                                                    _scaleAnimation,
                                                                controller:
                                                                    _controller,
                                                                isCollaped:
                                                                    isCollapsed,
                                                                setIsCollaped:
                                                                    setIsCollaped)
                                                            : widget
                                                                        .alterScreen ==
                                                                    ProfileScreen
                                                                        .id
                                                                ? ProfileScreen(
                                                                    duration:
                                                                        duration,
                                                                    isCollapsed:
                                                                        isCollapsed,
                                                                    screenWidth:
                                                                        screenWidth,
                                                                    scaleAnimation:
                                                                        _scaleAnimation,
                                                                    controller:
                                                                        _controller,
                                                                    isCollaped:
                                                                        isCollapsed,
                                                                    setIsCollaped:
                                                                        setIsCollaped)
                                                                : widget.alterScreen ==
                                                                        ShowBids
                                                                            .id
                                                                    ? ShowBids(
                                                                        duration:
                                                                            duration,
                                                                        isCollapsed:
                                                                            isCollapsed,
                                                                        screenWidth:
                                                                            screenWidth,
                                                                        scaleAnimation:
                                                                            _scaleAnimation,
                                                                        controller:
                                                                            _controller,
                                                                        isCollaped:
                                                                            isCollapsed,
                                                                        setIsCollaped:
                                                                            setIsCollaped)
                                                                    : widget.alterScreen == BidDetailScreen.id
                                                                        ? BidDetailScreen(
                                                                            duration:
                                                                                duration,
                                                                            isCollapsed:
                                                                                isCollapsed,
                                                                            screenWidth:
                                                                                screenWidth,
                                                                            scaleAnimation:
                                                                                _scaleAnimation,
                                                                            controller:
                                                                                _controller,
                                                                            isCollaped:
                                                                                isCollapsed,
                                                                            setIsCollaped:
                                                                                setIsCollaped)
                                                                        : widget.alterScreen == BusinessInformation.id
                                                                            ? BusinessInformation(
                                                                                duration: duration,
                                                                                isCollapsed: isCollapsed,
                                                                                screenWidth: screenWidth,
                                                                                scaleAnimation: _scaleAnimation,
                                                                                controller: _controller,
                                                                                isCollaped: isCollapsed,
                                                                                setIsCollaped: setIsCollaped)
                                                                            : widget.alterScreen == ViewDetailAwardedProject.id ? ViewDetailAwardedProject(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : widget.alterScreen == MyBids.id ? MyBids(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : widget.alterScreen == ViewDetailBiddedProject.id ? ViewDetailBiddedProject(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : widget.alterScreen == SettingsMenu.id ? SettingsMenu(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : widget.alterScreen == PasswordSettings.id ? PasswordSettings(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : widget.alterScreen == ProfileSettings.id ? ProfileSettings(duration: duration, isCollapsed: isCollapsed, screenWidth: screenWidth, scaleAnimation: _scaleAnimation, controller: _controller, isCollaped: isCollapsed, setIsCollaped: setIsCollaped) : null
                          ],
                        ),
                        !isCollapsed
                            ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _controller.reverse();
                                    setIsCollaped(true);
                                  },
                                  child: Container(color: Colors.transparent),
                                ),
                              )
                            : null
                      ].where((elem) => elem != null).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
