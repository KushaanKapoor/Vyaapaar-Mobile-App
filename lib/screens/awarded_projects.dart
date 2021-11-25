import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyaapaar/components/status_project_tile.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:vyaapaar/screens/view_detail_awarded_project.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class AwardedProjects extends StatefulWidget {
  static const String id = "Awarded Projects";

  const AwardedProjects({
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
  _AwardedProjectsState createState() => _AwardedProjectsState();
}

class _AwardedProjectsState extends State<AwardedProjects> {
  List<Map<String, dynamic>> awardedProjects = List<Map<String, dynamic>>();
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
    getAwardedProjects();
  }

  Future<void> getAwardedProjects() async {
    isLoading = true;
    try {
      final FirebaseUser user = await _auth.currentUser();
      final querySnapshot = await db
          .collection("users")
          .document(user.uid)
          .collection("bids")
          .where("isAwarded", isEqualTo: true)
          .getDocuments();
      List<Map<String, dynamic>> awardedProjectsInterim =
          List<Map<String, dynamic>>();

      for (int i = 0; i < querySnapshot.documents.length; i++) {
        DocumentSnapshot doc = querySnapshot.documents[i];
        Map<String, dynamic> awarded = doc.data;
        DocumentSnapshot projectDoc = await db
            .collection("projects")
            .document(awarded["projectId"])
            .get();
        awarded["projectDetails"] = projectDoc.data;
        awarded["id"] = projectDoc.documentID;
        awardedProjectsInterim.add(awarded);
      }
      setState(() {
        awardedProjects = awardedProjectsInterim;
        isLoading = false;
      });
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

  List<StatusProjectTile> displayProjects() {
    List<StatusProjectTile> list = List<StatusProjectTile>();
    for (int i = 0; i < awardedProjects.length; i++) {
      list.add(StatusProjectTile(
          status: awardedProjects[i]["isCompleted"] == true
              ? "Completed"
              : "Pending",
          index: i + 1,
          projectTitle: awardedProjects[i]["projectDetails"]["projectName"],
          budget: awardedProjects[i]["bidAmount"],
          description: awardedProjects[i]["projectDetails"]["description"],
          buttonText: "View Details",
          onPress: () async {
            await Navigator.pushNamed(context, ViewDetailAwardedProject.id,
                arguments: awardedProjects[i]);
            displayProjects();
          },
          buttonTextColor: Colors.blueAccent));
    }
    return list;
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
            onRefresh: getAwardedProjects,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 15.0),
                padding: !widget.isCollaped
                    ? EdgeInsets.only(left: 10.0)
                    : EdgeInsets.only(left: 0.0),
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
                      : displayProjects(),
                ),
              ),
            ),
          )),
    );
  }
}
