import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataUtils {
  static void showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  static String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    if (seconds > 9) {
      return '$seconds';
    } else {
      return seconds.toString().padLeft(2, '0');
    }
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}
