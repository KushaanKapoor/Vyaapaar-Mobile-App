import 'package:flutter/material.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/custom_dropdown.dart';
import 'package:vyaapaar/constants/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vyaapaar/screens/my_projects.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateProject extends StatefulWidget {
  static const String id = "Create Project";

  const CreateProject({
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
  // ignore: unused_field
  final AnimationController _controller;
  final bool isCollaped;
  final Function setIsCollaped;

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  String fieldOfWork = domains[0];
  String projectBudget = budgetRanges[0];
  String projectName = "";
  String projectDesc = "";

  void handlePostProject() async {
    try {
      Map<String, dynamic> projectDetails = Map();
      final currentUser = await _auth.currentUser();

      projectDetails["projectName"] = projectName;
      projectDetails["projectBudget"] = projectBudget;
      projectDetails["description"] = projectDesc;
      projectDetails["fieldOfWork"] = fieldOfWork;
      projectDetails["owner"] = currentUser.uid;
      projectDetails["dateCreated"] = FieldValue.serverTimestamp();
      projectDetails["isAwarded"] = false;
      projectDetails["isCompleted"] = false;

      final newProject =
          await firestoreInstance.collection('projects').add(projectDetails);
      final userRef =
          firestoreInstance.collection('users').document(currentUser.uid);

      await firestoreInstance.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        List updatedProjects = doc.data["myProjects"] ?? List();
        updatedProjects.add(newProject.documentID);
        transaction.update(userRef, {"myProjects": updatedProjects});
      });
      Fluttertoast.showToast(
          msg: "Project Posted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.popAndPushNamed(context, MyProjects.id);
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
          padding: EdgeInsets.only(left: 16, right: 16, top: 25),
          decoration: BoxDecoration(
            color: Color(0xFFE8E9EB),
            borderRadius: !widget.isCollapsed
                ? BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0))
                : BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Project Name',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400)),
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          setState(() {
                            projectName = value;
                          });
                        },
                        decoration: kInputDecotation.copyWith(
                            hintText: 'Eg:- Build a mobile app')),
                    SizedBox(height: 20.0),
                    Text(
                      'Project Description',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400)),
                        maxLines: 5,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          setState(() {
                            projectDesc = value;
                          });
                        },
                        decoration: kInputDecotation.copyWith(
                            hintText: 'Describe your Project')),
                    SizedBox(height: 20.0),
                    Text(
                      'Field of work',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    CustomDropdown(
                      listOfStrings: domains,
                      value: fieldOfWork,
                      setValue: (value) {
                        setState(() {
                          fieldOfWork = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Project Budget',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    CustomDropdown(
                      listOfStrings: budgetRanges,
                      value: projectBudget,
                      setValue: (value) {
                        setState(() {
                          projectBudget = value;
                        });
                      },
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Attachments (if any) (Only PDF, DOC, PPT)',
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400)),
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: kInputDecotation.copyWith(
                            hintText: 'No File Chosen')),
                    SizedBox(
                      height: 9.0,
                    ),
                    ResizableActionButton(
                      isButtonDisabled: false,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPress: () {
                        if (projectName != "" && projectDesc != "") {
                          handlePostProject();
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Cannot keep Project Name or Project Description empty",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black12,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      text: 'Post',
                      width: 100,
                    ),
                  ]),
            ),
          )),
    );
  }
}
