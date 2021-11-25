import 'package:flutter/material.dart';
import 'package:vyaapaar/components/resizable_action_button.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletePopup extends StatelessWidget {
  final String projectName;
  final Function handleCompleteProject;

  CompletePopup(
      {@required this.projectName, @required this.handleCompleteProject});

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
                    child: Text("Complete Confirmation",
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
                    'You are about to award to declare that your project $projectName is completed.',
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500))),
                SizedBox(
                  height: 10.0,
                ),
                Text('Do you want to proceed?',
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
                        handleCompleteProject();
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
