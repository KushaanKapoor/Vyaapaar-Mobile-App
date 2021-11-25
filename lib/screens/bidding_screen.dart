import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/constants/text_feild.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:fluttertoast/fluttertoast.dart';

final Firestore db = Firestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class BiddingScreen extends StatefulWidget {
  final String projectID;
  BiddingScreen({@required this.projectID});

  @override
  _BiddingScreenState createState() => _BiddingScreenState();
}

class _BiddingScreenState extends State<BiddingScreen> {
  String bidAmount;

  String jobProposal;

  Future<void> bid() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      final DocumentReference projectBidDocRef = await db
          .collection("projects")
          .document(widget.projectID)
          .collection("bids")
          .add({
        "bidAmount": bidAmount,
        "jobProposal": jobProposal,
        "bidder": user.uid,
        "dateCreated": FieldValue.serverTimestamp()
      });
      await db
          .collection("users")
          .document(user.uid)
          .collection("bids")
          .document(projectBidDocRef.documentID)
          .setData({
        "bidAmount": bidAmount,
        "jobProposal": jobProposal,
        "projectId": widget.projectID,
        "dateCreated": FieldValue.serverTimestamp()
      });
      Fluttertoast.showToast(
          msg: "Bid Submitted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "There was some problem. Please try again",
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
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 455 + MediaQuery.of(context).viewInsets.bottom,
        padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            color: Color(0xFFE8E9EB),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Bid on Project",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700))),
              SizedBox(
                height: 20,
              ),
              Text('Bid Amount',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400)),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      bidAmount = value;
                    });
                  },
                  decoration:
                      kInputDecotation.copyWith(hintText: 'Enter Bid Amount')),
              SizedBox(
                height: 20.0,
              ),
              Text('Job Proposal',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500))),
              SizedBox(
                height: 5.0,
              ),
              TextField(
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400)),
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    setState(() {
                      jobProposal = value;
                    });
                  },
                  decoration: kInputDecotation.copyWith(
                      hintText: 'Enter Job Proposal')),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Company Profile',
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 5.0),
              TextField(
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400)),
                  textAlign: TextAlign.left,
                  onChanged: (value) {},
                  decoration:
                      kInputDecotation.copyWith(hintText: 'No File Chosen')),
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
                      if (bidAmount != "") {
                        bid().then((value) => Navigator.pop(context, true));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Cannot keep Bid Amount empty.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black12,
                            textColor: Colors.white,
                            fontSize: 16.0);
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
                      Navigator.pop(context);
                    },
                    text: 'Back to Project Detail',
                    width: 220,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ]),
      ),
    );
  }
}
