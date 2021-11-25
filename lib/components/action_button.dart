import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final Color color;
  final Function onPress;
  final String text;

  ActionButton({@required this.color,@required this.onPress,@required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
          minWidth: 400.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.blueGrey
            ),
          ),
        ),
      ),
    );
  }
}