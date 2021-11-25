import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyaapaar/components/bid_on_project_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:vyaapaar/utils/truncate_with_ellipsis.dart";
import 'package:vyaapaar/screens/view_detail_all_projects.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore firestoreInstance = Firestore.instance;

class BidOnProjects extends StatefulWidget {
  static const String id = "Bid On Projects";

  const BidOnProjects({
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
  _BidOnProjectsState createState() => _BidOnProjectsState();
}

class _BidOnProjectsState extends State<BidOnProjects> {
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
    initialiseProjects();
  }

  Future<void> initialiseProjects() async {
    isLoading = true;

    try {
      final user = await _auth.currentUser();
      final querySnapshot = await firestoreInstance
          .collection("projects")
          .where("isAwarded", isEqualTo: false)
          .where("isDeleted", isEqualTo: null)
          .getDocuments();
      projects.clear();
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        final DocumentSnapshot doc = querySnapshot.documents[i];
        if (doc.data["owner"] != user.uid) {
          Map<String, dynamic> project = doc.data;
          project["id"] = doc.documentID;
          final QuerySnapshot bidsQuery = await firestoreInstance
              .collection("projects")
              .document(doc.documentID)
              .collection("bids")
              .where("bidder", isEqualTo: user.uid)
              .getDocuments();
          if (bidsQuery.documents.length == 0) {
            projects.add(project);
          }
        }
      }

      setState(() {
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

  List<BidProjectTile> populateProjects() {
    List<BidProjectTile> displayProjects = List<BidProjectTile>();
    for (int i = 0; i < projects.length; i++) {
      displayProjects.add(BidProjectTile(
          index: i + 1,
          projectTitle: projects[i]["projectName"],
          budget: projects[i]["projectBudget"],
          description: truncateWithEllipsis(70, projects[i]["description"]),
          buttonText: "View Details",
          onPress: () async {
            var isBidded = await Navigator.pushNamed(
                context, ViewDetailAllProject.id,
                arguments: projects[i]);
            if (isBidded == true) {
              initialiseProjects();
            }
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
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10.0),
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
            onRefresh: initialiseProjects,
            child: SingleChildScrollView(
              physics:
                  widget.isCollapsed ? null : NeverScrollableScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(top: 5.0),
                padding: !widget.isCollaped
                    ? EdgeInsets.only(left: 10.0)
                    : EdgeInsets.only(left: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      : populateProjects(),
                ),
              ),
            ),
          )),
    );
  }
}
