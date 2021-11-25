import 'package:flutter/material.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vyaapaar/utils/award_project.dart';

class AwardPopup extends StatelessWidget {
  final String projectName;
  final String businessName;
  final String bidAmount;
  final String bidId;
  final String projectId;

  AwardPopup(
      {@required this.projectName,
      @required this.businessName,
      @required this.bidAmount,
      @required this.bidId,
      @required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 10),
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Award Confirmation",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.none,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700)))),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    'You are about to award $projectName to $businessName at amount $bidAmount.',
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                    'You will not be able to edit the project details once it is awarded. Do you want to proceed?',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ResizableActionButton(
                      isButtonDisabled: false,
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPress: () async {
                        await awardProject(projectId, bidId);
                        Navigator.pop(context);
                      },
                      text: 'Confirm',
                      width: 100,
                    ),
                    ResizableActionButton(
                      isButtonDisabled: false,
                      color: Colors.black87,
                      textColor: Colors.white,
                      onPress: () {
                        Navigator.pop(context);
                      },
                      text: 'Cancel',
                      width: 100,
                    ),
                  ],
                ),
              ],
            )));
  }
}
