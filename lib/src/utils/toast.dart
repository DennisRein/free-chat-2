

import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';

class FreeToast {
  static void showToast(String msg) {
    if(!(Platform.isAndroid || Platform.isIOS)) return;
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  }
}