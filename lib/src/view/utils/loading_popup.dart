import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPopup {
  Widget buildPopupDialog(BuildContext context, String text) {
    return new AlertDialog(
      title: Text(text),
      content: SingleChildScrollView(
        child: Center(
          child:
          const SpinKitRing(color: Colors.blue),
        )
      ),
    );
  }

  static void build(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadingPopup().buildPopupDialog(context, text),
    );
  }
}