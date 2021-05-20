import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirmation{

  static Widget mainArea(context, argreeToDel, disagree,  f,  s,  t) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 203),
    padding: const EdgeInsets.only(bottom: 30),
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 4,
          offset: Offset(1, 1),
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(10)),
      // BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        buttonsArea(context, argreeToDel, disagree, f, s, t),
      ],
    ),
  );

  static Widget buttonsArea(context, argreeToDel, disagree, f, s, t) => Container(
    child: new Form(
      child: new Column(
        children: <Widget>[
          titleArea(f),
          confirmDeletion(context, argreeToDel, s),
          disagreeToDel(context, disagree, t),
        ],
      ),
    ),
  );

  static Widget titleArea(f) => Container(
    margin: const EdgeInsets.only(left: 120, right: 120, top: 30),
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 4,
          offset: Offset(1, 1),
        ),
      ],
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Text(
      f,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
    ),
  );

  static Widget disagreeToDel(context, disagree, s) => MaterialButton(
    onPressed: disagree,
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Text(
        s,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  );

  static Widget confirmDeletion(context, void argreeToDel(), t) => MaterialButton(
    onPressed: argreeToDel,
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Text(
        t,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  );
}