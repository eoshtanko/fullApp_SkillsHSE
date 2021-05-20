 import 'package:flutter/material.dart';

class Error{
  static void errorSnackBar(GlobalKey<ScaffoldState> globalKey) {
    globalKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 5),
        content: Text(
          "\n\nПроизошла ошибка. Попробуйте повторить запрос позже.\n\n\n\n\n",
          style: TextStyle(fontSize: 20, color: Colors.blue),
        )));
  }
}