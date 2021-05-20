import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EWidgets {
  static Widget prof(Profile profile) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: 50,
        height: 50,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: (profile.photoUri == null || profile.photoUri.isEmpty)
                  ? null
                  : MemoryImage(profile.photoUri),
            )),
      ),
    );
  }

  static DialogLoading dialogLoading;

  static Widget profile(void goToProf(), Profile profile) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    goToProf();
                  },
                  child: prof(profile),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.,
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    goToProf();
                  },
                  child: new Container(
                    padding: EdgeInsets.only(left: 7.0, top: 20.0),
                    child: new Text(
                      profile.name + " " + profile.surname,
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  static Widget dataInfoAbout(String txt) {
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

  static Widget titleWidget(String tit) {
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
}
