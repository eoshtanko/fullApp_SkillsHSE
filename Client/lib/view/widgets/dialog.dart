import 'package:flutter/material.dart';

// class Dialog{
//   DialogLoading dialogLoading = new DialogLoading(context: null)
// }

class DialogLoading {
  static const String _Default_Text = "Загружаю...";
  final BuildContext context;
  final String text;
  static bool active = false;

  DialogLoading({@required this.context, this.text});

  void show() {
    if(!active) {
      active = true;
      AlertDialog alert = AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(strokeWidth: 3.0),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(text == null ? _Default_Text : text)),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  void stop() {
    if(active) {
      active = false;
      Navigator.pop(context);
    }
  }
}
