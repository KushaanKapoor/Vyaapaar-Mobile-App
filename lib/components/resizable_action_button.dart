import 'package:flutter/material.dart';

class ResizableActionButton extends StatelessWidget {
  final Color color;
  final Function onPress;
  final String text;
  final double width;
  final Color textColor;
  final isButtonDisabled;

  ResizableActionButton(
      {@required this.color,
      @required this.onPress,
      @required this.text,
      @required this.width,
      @required this.textColor,
      @required this.isButtonDisabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: isButtonDisabled ? Colors.blueGrey : color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: isButtonDisabled ? null : onPress,
          minWidth: width,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
