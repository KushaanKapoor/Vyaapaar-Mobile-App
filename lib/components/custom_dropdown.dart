import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> listOfStrings;
  final Function setValue;
  final String value;

  CustomDropdown(
      {@required this.listOfStrings,
      @required this.setValue,
      @required this.value});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  DropdownButtonHideUnderline getDropdownButoon() {
    List<DropdownMenuItem> dropdownItems = [];

    for (String item in widget.listOfStrings) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(
          item,
          textAlign: TextAlign.left,
          style: GoogleFonts.raleway(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400)),
        ),
        value: item,
      ));
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: widget.value == null ? widget.listOfStrings[0] : widget.value,
          items: dropdownItems,
          isDense: true,
          iconSize: 42,
          icon: Icon(Icons.arrow_drop_down),
          style: GoogleFonts.raleway(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400)),
          onChanged: (value) {
            widget.setValue(value);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Material(
          elevation: 5.0,
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              width: 400.0,
              child: getDropdownButoon())),
    );
  }
}
