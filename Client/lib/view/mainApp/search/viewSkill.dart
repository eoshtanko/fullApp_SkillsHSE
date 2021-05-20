import 'dart:convert';
import 'dart:ui';

import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/exchanges/currentEx.dart';
import 'package:demoapp/view/mainApp/exchanges/inEx.dart';
import 'package:demoapp/view/mainApp/exchanges/outEx.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/error.dart';

final globalKey = GlobalKey<ScaffoldState>();
BuildContext _context;
Skill notMySkill;
String _des;
final _desController = TextEditingController();

class ViewSkill extends StatefulWidget{
  final Skill skill;

  ViewSkill({
    Key key,
    @required this.skill,
  });

  @override
  ViewSkillState createState() => ViewSkillState(skill: skill);
}

class ViewSkillState extends State<ViewSkill> {
  final Skill skill;
  Profile pr;

  ViewSkillState({
    Key key,
    @required this.skill,
  }) : pr = Profile.fromJson(skill.user);

  @override
  void initState() {

    _desController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    notMySkill = skill;
    dialogLoading = DialogLoading(context: _context);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
            onPressed: _perform,
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            image: DecorationImage(
              image: AssetImage('assets/images/фон.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: new ListView(
            children: [
              _titleArea(),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 30),
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
                    _titleWidget("С кем:"),
                    _profile(),
                    _titleWidget("Навык:"),
                    _dataShortInfoAbout(),
                    (skill.description == null || skill.description.isEmpty)
                        ? new Container()
                        : _titleWidget("Подробное описание:"),
                    (skill.description == null || skill.description.isEmpty)
                        ? new Container()
                        : _dataInfoAbout(),
                    _titleWidget("Мое предложение:"),
                    MySkill(),
                    _titleWidget("Сообщение:"),
                    _desAbout(),
                    _saveButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _saveButtons(context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text(
                  "Предложить обмен",
                  style: TextStyle(fontSize: 17),
                ),
                textColor: Colors.white,
                color: Colors.blue[300],
                onPressed: () => _submit(),
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

  void _submit() async {
    final formInfo = formKeyInfo.currentState;
    Exchange exchange = new Exchange();
    if (dropdownValue != null) {
      formInfo.save();
      hideKeyboard();
      FocusScope.of(_context).unfocus();
      exchange.status = 0;
      exchange.skill1 = dropdownValue.name;
      exchange.skill2 = skill.name;
      exchange.description = _des;
      exchange.senderMail = CurrentUser.profile.email;
      exchange.receiverMail = skill.userMail;
      exchange.users = new List<Profile>();
      exchange.whoWantMail = dropdownValue.status == 2
          ? CurrentUser.profile.email
          : skill.userMail;


      if(inExc != null) {
        for (Exchange exc in inExc) {

          if (
              (exc.skill1 == exchange.skill1
                  && exc.skill2 == exchange.skill2 &&
                  exc.senderMail == exchange.senderMail &&
                  exc.receiverMail == exchange.receiverMail)
              || (exc.skill1 == exchange.skill2
                      && exc.skill2 == exchange.skill1
                      && exc.senderMail == exchange.receiverMail
                      && exc.receiverMail == exchange.senderMail)
          ) {
            globalKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Text(
                  "\n\n Данный обмен уже существует.\n\n\n\n\n",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )));
            return;
          }
        }
      }
      if(outExc != null) {
        for (Exchange exc in outExc) {
          if (
              (exc.skill1 == exchange.skill1 && exc.skill2 == exchange.skill2 &&
                  exc.senderMail == exchange.senderMail &&
                  exc.receiverMail == exchange.receiverMail)
              || (
                  exc.skill1 == exchange.skill2
                      && exc.skill2 == exchange.skill1
                      && exc.senderMail == exchange.receiverMail
                      && exc.receiverMail == exchange.senderMail
              )) {
            globalKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Text(
                  "\n\n Данный обмен уже существует.\n\n\n\n\n",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )));
            return;
          }
        }
      }
      if(curExc != null) {
        for (Exchange exc in curExc) {
          if (
              (exc.skill1 == exchange.skill1 && exc.skill2 == exchange.skill2 &&
                  exc.senderMail == exchange.senderMail &&
                  exc.receiverMail == exchange.receiverMail)
              || (
                  exc.skill1 == exchange.skill2
                      && exc.skill2 == exchange.skill1
                      && exc.senderMail == exchange.receiverMail
                      && exc.receiverMail == exchange.senderMail
              )) {
            globalKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Text(
                  "\n\n Данный обмен уже существует.\n\n\n\n\n",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                )));
            return;
          }
        }
      }

      dialogLoading.show();
      Api.addExchange(exchange)
          .then((value) => {
                if (value.isSuccess())
                  {
                    dialogLoading.stop(),
                    dropdownValue = null,
                    // Api.getOutEx()
                    //     .then((value) => {
                    //           if (value.isSuccess())
                    //             {
                    //               dialogLoading.stop(),
                    //               outExc = value.getData(),
                    //             }
                    //           else
                    //             {
                    //               Error.errorSnackBar(globalKey),
                    //               dialogLoading.stop(), // todo timer
                    //             }
                    //         })
                    //     .timeout(Duration(seconds: 90))
                    //     .catchError((Object object) => {
                    //           dialogLoading.stop(),
                    //           Error.errorSnackBar(globalKey)
                    //         }),
                    Navigator.pop(_context),
                  }
                else
                  {dialogLoading.stop(), Error.errorSnackBar(globalKey)}
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    }
  }

  void _perform() {
    dropdownValue = null;
    Navigator.pop(_context);
  }

  DialogLoading dialogLoading;

  Widget _prof() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: 50,
        height: 50,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: (pr.photoUri == null || pr.photoUri.isEmpty)
                  ? null
                  : MemoryImage(
                      pr.photoUri), //MemoryImage(CurrentUser.profile.photoUri),
            )),
      ),
    );
  }

  void goToProfile() {
    Navigator.push(_context,
        MaterialPageRoute(builder: (context) => NotMyProfile(profile: pr, fromOut: false)));
  }

  Widget _profile() {
    return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 25.0, top: 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new GestureDetector(
                  onTap: goToProfile,
                  child: _prof(),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.,
              children: <Widget>[
                new GestureDetector(
                  onTap: goToProfile,
                  child: new Container(
                    padding: EdgeInsets.only(left: 7.0, top: 20.0),
                    child: new Row(children: <Widget>[
                      new Text(
                        pr.name + " " + pr.surname + " ",
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      new Text(
                        (skill.status == 1 ? "может" : "хочет"),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.blue,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _dataShortInfoAbout() {
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
                              skill.name,
                              //controller: _emailController,
                            ))),
                  ],
                ))),
      ),
    );
  }

  Widget _dataInfoAbout() {
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
                          child: new Text(
                        skill.description,
                      )),
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget _titleWidget(String tit) {
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

  Widget _titleArea() => Container(
        margin:
            const EdgeInsets.only(left: 110, right: 110, top: 30, bottom: 0),
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
          'Обмен',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  final formKeyInfo = new GlobalKey<FormState>();

  Widget _desAbout() {
    return Container(
      child: new Form(
        key: formKeyInfo,
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: EdgeInsets.symmetric(horizontal: 0),
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
                              padding: EdgeInsets.only(bottom: 15),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:
                                        "Добавьте сообщение (не более 300 знаков)"),
                                maxLength: 300,
                                // controller: _aboutController,
                                maxLengthEnforced: true,
                                maxLines: 8,
                                controller: _desController,
                                onSaved: (val) {
                                  if (val != null) {
                                    _des = val;
                                  }
                                },
                                //controller: _emailController,
                              ))),
                    ],
                  ))),
        ),
      ),
    );
  }
}

class MySkill extends StatefulWidget {
  @override
  _MySkillState createState() => _MySkillState();
}

Skill dropdownValue;

class _MySkillState extends State<MySkill> {
  List<Skill> values;

  initState() {
    super.initState();
    if (notMySkill.status == 1) {
      if (CurrentUser.profile.skills
              .where((element) => element.status == 1)
              .length >
          0) {
        dropdownValue = CurrentUser.profile.skills
            .where((element) => element.status == 1)
            .toList()[0];
        values = CurrentUser.profile.skills
            .where((element) => element.status == 1)
            .toList();
      } else {
        values = List.empty();
      }
    } else if (notMySkill.status == 2) {
      {
        if (CurrentUser.profile.skills
                .where((element) => element.status == 2)
                .length >
            0) {
          dropdownValue = CurrentUser.profile.skills
              .where((element) => element.status == 2)
              .toList()[0];
          values = CurrentUser.profile.skills
              .where((element) => element.status == 2)
              .toList();
        } else {
          values = List.empty();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          border: values.length > 0 ? Border.all(color: Colors.grey): Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: values.length > 0
              ? DropdownButton<Skill>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  underline: Container(),
                  onChanged: (Skill newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: values.map<DropdownMenuItem<Skill>>((Skill value) {
                    return DropdownMenuItem<Skill>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                )
              : new Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text(
                    notMySkill.status == 2
                        ? "Сначала добавьте в профиле навыки,"
                            " которые хотели бы получить!"
                        : "Сначала добавьте в профиле навыки,"
                            " которыми могли бы поделиться!",
                    style: TextStyle(color: Colors.red[600], fontSize: 14),
                  ))));
}
