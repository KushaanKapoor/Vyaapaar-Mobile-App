import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyaapaar/screens/bid_on_projects.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:vyaapaar/screens/bidding_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;

class ViewDetailAllProject extends StatefulWidget {
  static const String id = "View Available Project";

  const ViewDetailAllProject({
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
  _ViewDetailAllProjectState createState() => _ViewDetailAllProjectState();
}

class _ViewDetailAllProjectState extends State<ViewDetailAllProject> {
  Map<String, dynamic> project;
  Map<String, dynamic> ownerDetails;
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
      Map<String, dynamic> project = ModalRoute.of(context).settings.arguments;
      getProjectDetails(project["id"], project["owner"]);
    });
  }

  // ignore: non_constant_identifier_names
  void getProjectDetails(String id, String owner_id) async {
    isLoading = true;
    try {
      final doc =
          await firestoreInstance.collection("projects").document(id).get();
      final owner = await getOwnerDetails(owner_id);

      setState(() {
        project = doc.data;
        project["id"] = doc.documentID;
        ownerDetails = owner;
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

  Future<Map<String, dynamic>> getOwnerDetails(String id) async {
    final doc = await firestoreInstance.collection("users").document(id).get();
    return doc.data;
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
                      topRight: Radius.circular(40.0))),
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
                        SizedBox(height: 10.0),
                        Text(
                          'Project Name',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${project["projectName"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Project Owner',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${ownerDetails["businessName"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Project Description',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${project["description"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Field of work',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${project["fieldOfWork"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Project Budget',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${project["projectBudget"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Attachments',
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
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ResizableActionButton(
                              isButtonDisabled: false,
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPress: () async {
                                var isBidded = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => BiddingScreen(
                                        projectID: project["id"]));
                                if (isBidded == true) {
                                  Navigator.pop(context, true);
                                }
                              },
                              text: 'Bid',
                              width: 120,
                            ),
                            ResizableActionButton(
                              isButtonDisabled: false,
                              color: Colors.black87,
                              textColor: Colors.white,
                              onPress: () {
                                Navigator.popAndPushNamed(
                                    context, BidOnProjects.id);
                              },
                              text: 'Back to Browse',
                              width: 220,
                            ),
                          ],
                        ),
                      ],
              ),
            ),
          )),
    );
  }
}
