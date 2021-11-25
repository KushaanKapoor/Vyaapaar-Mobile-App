import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableCard extends StatelessWidget {
  final double length;
  final String textLine1;
  final String textLine2;
  final double fontSize;
  final int numericalValue;

  ReusableCard({ @required this.length, @required this.textLine1, this.textLine2, @required this.numericalValue, @required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: length,
      width: length,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(50.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Text(
            textLine1,
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w500)
            ),
         
          ),
          Text(
            textLine2,
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w500)
            )
          ),
          Text(
            numericalValue.toString(),
            style: GoogleFonts.raleway(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w500)
            )
          ),
        ]
      ),

    );
  }
}