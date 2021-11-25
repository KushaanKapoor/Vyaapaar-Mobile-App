import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyaapaar/components/status_project_tile.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:vyaapaar/screens/view_detail_my_projects.dart';
import 'package:vyaapaar/utils/truncate_with_ellipsis.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class MyProjects extends StatefulWidget {
  static const String id = "My Projects";

  const MyProjects({
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
  _MyProjectsState createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  List projects = List();
  bool isLoading;

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
    getMyProjects();
  }

  Future<void> getMyProjects() async {
    isLoading = true;

    try {
      final user = await _auth.currentUser();
      final userDetails =
          await firestoreInstance.collection("users").document(user.uid).get();
      final projectIDs = userDetails.data["myProjects"];
      projects.clear();
      for (int i = 0; i < projectIDs.length; i++) {
        // ignore: non_constant_identifier_names
        String p_id = projectIDs[i];
        final doc =
            await firestoreInstance.collection("projects").document(p_id).get();
        // ignore: non_constant_identifier_names
        if (doc.data["isDeleted"] == null) {
          // ignore: non_constant_identifier_names
          Map p_map = doc.data;
          p_map["id"] = doc.documentID;
          projects.add(p_map);
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('error' + e.toString());
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

  List<StatusProjectTile> populateMyProjects() {
    List<StatusProjectTile> displayProjects = List<StatusProjectTile>();
    for (int i = 0; i < projects.length; i++) {
      displayProjects.add(StatusProjectTile(
          index: i + 1,
          status: projects[i]["isCompleted"]
              ? "Completed"
              : projects[i]["isAwarded"]
                  ? "Awarded"
                  : "Pending",
          projectTitle: projects[i]["projectName"],
          budget: projects[i]["projectBudget"],
          description: truncateWithEllipsis(70, projects[i]["description"]),
          buttonText: "View Details",
          onPress: () async {
            await Navigator.pushNamed(context, ViewDetailMyProject.id,
                arguments: projects[i]);
            await getMyProjects();
          },
          buttonTextColor: Colors.blueAccent));
    }
    return displayProjects;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
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
        child: RefreshIndicator(
          onRefresh: getMyProjects,
          child: SingleChildScrollView(
            child: Container(
              padding: !widget.isCollaped
                  ? EdgeInsets.only(left: 10.0)
                  : EdgeInsets.only(left: 0.0),
              margin: EdgeInsets.only(top: 15.0),
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
                      : populateMyProjects()),
            ),
          ),
        ),
      ),
    );
  }
}
