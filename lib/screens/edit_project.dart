import 'package:flutter/material.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/custom_dropdown.dart';
import 'package:vyaapaar/constants/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vyaapaar/components/delete_popup.dart';

final Firestore firestoreInstance = Firestore.instance;

class EditProject extends StatefulWidget {
  static const String id = "Edit Project";

  const EditProject({
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
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;

  Map<String, dynamic> currentProject;
  String fieldOfWork;
  String projectBudget;
  String projectName;
  String projectDesc;
  bool isLoading = true;

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
    Future.delayed(Duration.zero, () {
      currentProject = ModalRoute.of(context).settings.arguments;
      getProjectDetails(currentProject["id"]);
    });
  }

  void getProjectDetails(String id) async {
    isLoading = true;

    try {
      final doc =
          await firestoreInstance.collection("projects").document(id).get();

      setState(() {
        currentProject = doc.data;
        currentProject["id"] = doc.documentID;
        fieldOfWork = currentProject["fieldOfWork"];
        projectBudget = currentProject["projectBudget"];
        projectName = currentProject["projectName"];
        projectDesc = currentProject["description"];
        isLoading = false;
      });

      _nameController = new TextEditingController(text: projectName);
      _descriptionController = new TextEditingController(text: projectDesc);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Check you Network Connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void handleUpdateProject() async {
    try {
      await firestoreInstance
          .collection("projects")
          .document(currentProject["id"])
          .updateData({
        "projectName": projectName,
        "fieldOfWork": fieldOfWork,
        "projectBudget": projectBudget,
        "description": projectDesc
      });
      Fluttertoast.showToast(
          msg: "Project Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context, false);
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

  Future<void> handleDeleteProject() async {
    try {
      await firestoreInstance
          .collection("projects")
          .document(currentProject["id"])
          .updateData({"isDeleted": true});
      Fluttertoast.showToast(
          msg: "Project Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      Navigator.pop(context, true);
      Navigator.pop(context);
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
                    topRight: Radius.circular(40.0)),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: isLoading
                      ? <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 60.0,
                              width: 60.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                                value: null,
                                strokeWidth: 4.0,
                              ),
                            ),
                          ),
                        ]
                      : <Widget>[
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
                              controller: _nameController,
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
                              controller: _descriptionController,
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
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ResizableActionButton(
                                isButtonDisabled: false,
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                                onPress: () {
                                  if (projectName != "" && projectDesc != "") {
                                    handleUpdateProject();
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
                                text: 'Update Project Details',
                                width: 150,
                              ),
                              ResizableActionButton(
                                isButtonDisabled: false,
                                color: Colors.black87,
                                textColor: Colors.white,
                                onPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => DeletePopup(
                                            deleteProject: handleDeleteProject,
                                          ));
                                },
                                text: 'Delete Project',
                                width: 100,
                              ),
                            ],
                          ),
                        ]),
            ),
          )),
    );
  }
}
