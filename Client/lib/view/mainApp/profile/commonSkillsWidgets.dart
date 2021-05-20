
import 'package:demoapp/logic/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets{
  static Widget mainTitleWidget(String txt) =>
      Container(
        margin: const EdgeInsets.only(
            left: 110, right: 110, top: 50, bottom: 20),
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
          txt,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  static Widget subTitleWidget(String tit) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  tit,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  static Widget dropDownMenuWidget(Widget w, bool changed) {
    return Container(
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: changed ? Colors.grey : Colors.red),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.0, right: 6.0, top: 0.0),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: w,
                  )),
            ),
          ],
        ));
  }

  static Widget saveButtonWidget(void submit(context, isNew, skill), context, isNew, skill) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 35.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Сохранить"),
                    textColor: Colors.white,
                    color: Colors.blue[300],
                    onPressed: () => submit(context, isNew, skill),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  static Widget dataWidget(String txt) {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: Container(
                          padding: EdgeInsets.only(bottom: 0),
                          child: new Text(
                            txt,
                          )),
                    ),
                  ],
                ))),
      ),
    );
  }
}