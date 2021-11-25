import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vyaapaar/components/status_project_tile.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:vyaapaar/constants/colors.dart';
import 'package:vyaapaar/screens/view_detail_bidded_project.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class MyBids extends StatefulWidget {
  static const String id = "Bidded Projects";

  const MyBids({
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
  _MyBidsState createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {
  List<Map<String, dynamic>> myBids = List<Map<String, dynamic>>();
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
    getBiddedProjects();
  }

  Future<void> getBiddedProjects() async {
    isLoading = true;

    try {
      List<Map<String, dynamic>> projectsList = List<Map<String, dynamic>>();
      final FirebaseUser user = await _auth.currentUser();
      final QuerySnapshot bidsQuery = await db
          .collection("users")
          .document(user.uid)
          .collection("bids")
          .getDocuments();

      for (int i = 0; i < bidsQuery.documents.length; i++) {
        final Map<String, dynamic> bid = bidsQuery.documents[i].data;
        final DocumentSnapshot projectDoc =
            await db.collection("projects").document(bid["projectId"]).get();
        bid["projectDetails"] = projectDoc.data;
        bid["projectDetails"]["id"] = projectDoc.documentID;

        if (bid["projectDetails"]["isDeleted"] == true) {
          bid["status"] = "Cancelled";
        } else if (bid["projectDetails"]["isAwarded"] == false) {
          bid["status"] = "Active";
        } else if (bid["projectDetails"]["winningBid"]["bidder"] == user.uid) {
          bid["status"] = "Awarded";
        } else {
          bid["status"] = "Not Awarded";
        }
        projectsList.add(bid);
      }
      setState(() {
        myBids = projectsList;
        isLoading = false;
      });
    } catch (e) {
      print("this is the error" + e.toString());
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

  List<StatusProjectTile> displayMyBids() {
    List<StatusProjectTile> bidTiles = List<StatusProjectTile>();
    int index = 1;
    myBids.forEach((bid) {
      bidTiles.add(StatusProjectTile(
        index: index,
        status: bid["status"],
        onPress: () {
          Navigator.pushNamed(context, ViewDetailBiddedProject.id,
              arguments: bid);
        },
        budget: bid["bidAmount"],
        description: bid["projectDetails"]["description"],
        buttonText: "View Details",
        projectTitle: bid["projectDetails"]["projectName"],
        buttonTextColor: kPrimaryBlue,
      ));
      index++;
    });
    return bidTiles;
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
            onRefresh: getBiddedProjects,
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
                      : displayMyBids(),
                ),
              ),
            ),
          )),
    );
  }
}
