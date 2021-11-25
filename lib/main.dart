import 'package:flutter/material.dart';
import 'package:vyaapaar/screens/awarded_projects.dart';
import 'package:vyaapaar/screens/bid_detail_screen.dart';
import 'package:vyaapaar/screens/bid_on_projects.dart';
import 'package:vyaapaar/screens/business_information.dart';
import 'package:vyaapaar/screens/create_project.dart';
import 'package:vyaapaar/screens/edit_project.dart';
import 'package:vyaapaar/screens/landing_screen.dart';
import 'package:vyaapaar/screens/main_screen.dart';
import 'package:vyaapaar/screens/my_projects.dart';
import 'package:vyaapaar/screens/password_settings.dart';
import 'package:vyaapaar/screens/profile_screen.dart';
import 'package:vyaapaar/screens/profile_settings.dart';
import 'package:vyaapaar/screens/signup2.dart';
import 'package:vyaapaar/screens/view_detail_all_projects.dart';
import 'screens/view_detail_my_projects.dart';
import 'screens/login_screen.dart';
import 'screens/signup1.dart';
import 'package:vyaapaar/screens/forgot_password.dart';
import 'package:vyaapaar/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/show_bids.dart';
import 'screens/view_detail_awarded_project.dart';
import 'screens/my_bids_screen.dart';
import 'screens/view_detail_bidded_project.dart';
import 'screens/settings_menu.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
var user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  user = await _auth.currentUser();

  runApp(Vyaapaar());
}

class Vyaapaar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyaapaar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        LandingScreen.id: (context) => LandingScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreenOne.id: (context) => SignUpScreenOne(),
        SignUpScreenTwo.id: (context) => SignUpScreenTwo(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        Dashboard.id: (context) => MainScreen(Dashboard.id),
        CreateProject.id: (context) => MainScreen(CreateProject.id),
        BidOnProjects.id: (context) => MainScreen(BidOnProjects.id),
        MyProjects.id: (context) => MainScreen(MyProjects.id),
        AwardedProjects.id: (context) => MainScreen(AwardedProjects.id),
        ViewDetailAllProject.id: (context) =>
            MainScreen(ViewDetailAllProject.id),
        ViewDetailMyProject.id: (context) => MainScreen(ViewDetailMyProject.id),
        EditProject.id: (context) => MainScreen(EditProject.id),
        ProfileScreen.id: (context) => MainScreen(ProfileScreen.id),
        ShowBids.id: (context) => MainScreen(ShowBids.id),
        BidDetailScreen.id: (context) => MainScreen(BidDetailScreen.id),
        BusinessInformation.id: (context) => MainScreen(BusinessInformation.id),
        ViewDetailAwardedProject.id: (context) =>
            MainScreen(ViewDetailAwardedProject.id),
        MyBids.id: (context) => MainScreen(MyBids.id),
        ViewDetailBiddedProject.id: (context) =>
            MainScreen(ViewDetailBiddedProject.id),
        SettingsMenu.id: (context) => MainScreen(SettingsMenu.id),
        PasswordSettings.id: (context) => MainScreen(PasswordSettings.id),
        ProfileSettings.id: (context) => MainScreen(ProfileSettings.id)
      },
      initialRoute: user == null ? LandingScreen.id : Dashboard.id,
    );
  }
}
