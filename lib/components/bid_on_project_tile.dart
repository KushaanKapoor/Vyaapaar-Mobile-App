import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BidProjectTile extends StatelessWidget {
  final int index;
  final String projectTitle;
  final String budget;
  final String description;
  final String buttonText;
  final Function onPress;
  final Color buttonTextColor;

  BidProjectTile(
      {@required this.index,
      @required this.projectTitle,
      @required this.budget,
      @required this.description,
      @required this.buttonText,
      @required this.onPress,
      @required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Text(
                '$index. $projectTitle',
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 5.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16)),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Bugdet: ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: budget),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(color: Colors.black, fontSize: 16)),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Description: ',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: description),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: OutlineButton(
                    shape: StadiumBorder(),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                              color: buttonTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                    ),
                    onPressed: onPress,
                    borderSide: BorderSide(
                      color: buttonTextColor,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  )),
            ]),
      ),
    );
  }
}
