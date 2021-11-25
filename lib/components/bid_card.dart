import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:vyaapaar/utils/truncate_with_ellipsis.dart";

class BidCard extends StatelessWidget {
  final double length;
  final String bidderName;
  final String bidAmount;
  final double fontSize;
  final Function onPress;

  BidCard(
      {@required this.length,
      @required this.bidderName,
      @required this.bidAmount,
      @required this.fontSize,
      @required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: length,
      padding: EdgeInsets.only(left: 10.0, top: 5.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 1.0,
          offset: Offset(1.0, 1.0),
        )
      ], color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 7,
              child: Text(truncateWithEllipsis(22, bidderName),
                  textAlign: TextAlign.left,
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500)))),
          Expanded(
            flex: 4,
            child: Text(bidAmount,
                textAlign: TextAlign.right,
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: fontSize + 1,
                        fontWeight: FontWeight.w500))),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
                splashColor: Colors.blueGrey,
                iconSize: 30,
                padding: EdgeInsets.all(0.0),
                icon: Icon(Icons.remove_red_eye, color: Colors.blueAccent),
                onPressed: onPress),
          )
        ],
      ),
    );
  }
}
