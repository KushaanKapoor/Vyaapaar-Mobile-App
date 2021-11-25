import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:vyaapaar/screens/business_information.dart';
import 'package:vyaapaar/components/award_popup.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;

class BidDetailScreen extends StatefulWidget {
  static const String id = "Bid Details";

  const BidDetailScreen({
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
  _BidDetailScreenState createState() => _BidDetailScreenState();
}

class _BidDetailScreenState extends State<BidDetailScreen> {
  Map<String, dynamic> bidDetails;
  Map<String, dynamic> project;
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
      Map<String, dynamic> arguments =
          ModalRoute.of(context).settings.arguments;
      project = arguments["project"];
      bidDetails = arguments["bidDetails"];
      bidDetails["bidderDetails"]["uid"] = project["owner"];
      getProjectDetails(project["id"]);
    });
  }

  void getProjectDetails(String id) async {
    isLoading = true;

    try {
      final doc =
          await firestoreInstance.collection("projects").document(id).get();

      var bidder;
      if (doc.data["isAwarded"]) {
        bidder = await firestoreInstance
            .collection("users")
            .document(doc.data["winningBid"]["bidder"])
            .get();
      }

      setState(() {
        project = doc.data;
        project["id"] = doc.documentID;

        if (project["isAwarded"]) {
          project["winningBid"]["businessName"] = bidder["businessName"];
        }

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
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
                          'Bidder Name',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${bidDetails["bidderDetails"]["businessName"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Bid Amount',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${bidDetails["bidAmount"]}',
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(height: 20.0),
                        Text(
                          'Job Proposal',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 5.0),
                        Text('${bidDetails["jobProposal"]}',
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
                        SizedBox(height: 30.0),
                        Container(
                            child: project["isAwarded"]
                                ? Text(
                                    'This project is already awarded to ${project["winningBid"]["businessName"]}.',
                                    style: GoogleFonts.raleway(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w500)),
                                  )
                                : null),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ResizableActionButton(
                              isButtonDisabled: project["isAwarded"],
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AwardPopup(
                                          bidAmount: bidDetails["bidAmount"],
                                          bidId: bidDetails["bidId"],
                                          businessName:
                                              bidDetails["bidderDetails"]
                                                  ["businessName"],
                                          projectName: project["projectName"],
                                          projectId: project["id"],
                                        ));

                                getProjectDetails(project["id"]);
                              },
                              text: 'Award Project',
                              width: 120,
                            ),
                            ResizableActionButton(
                              isButtonDisabled: false,
                              color: Colors.black87,
                              textColor: Colors.white,
                              onPress: () {
                                Navigator.pushNamed(
                                    context, BusinessInformation.id,
                                    arguments: bidDetails["bidderDetails"]);
                              },
                              text: 'Bidder Information',
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
