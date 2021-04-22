import 'package:flutter/material.dart';

class ErrorPopup {
  Widget buildPopupDialog(BuildContext context, String text) {
    return new AlertDialog(
      title: Text(text),
      content: SingleChildScrollView(
          child: Center(
            child: Text("An Error occured: $text, please try again later")
          )
      ),
    );
  }

  static void build(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ErrorPopup().buildPopupDialog(context, text),
    );
  }
}