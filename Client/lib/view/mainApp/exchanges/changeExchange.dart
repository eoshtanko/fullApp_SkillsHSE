import 'dart:ui';

import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'currentEx.dart';
import 'inEx.dart';
import 'outEx.dart';

final globalKey = GlobalKey<ScaffoldState>();
BuildContext _context;
String _des;
final _desController = TextEditingController();
Exchange myExchange;

class ChangeExchange extends StatefulWidget{
  final Exchange exchange;
  Profile withWhom;
  ChangeExchange({
    Key key,
    @required this.withWhom,
    @required this.exchange,
  });
  @override
  ChangeExchangeState createState() => ChangeExchangeState(exchange: exchange, withWhom: withWhom);
}

class ChangeExchangeState extends State<ChangeExchange> {
  final Exchange exchange;
  Profile withWhom;
  ChangeExchangeState({
    Key key,
    @required this.withWhom,
    @required this.exchange,
  });

  @override
  void initState() {
    formKeyInfo = new GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _desController.text =
        exchange.description == null ? "" : exchange.description;
    myExchange = exchange;
    _context = context;
    dialogLoading = DialogLoading(context: _context);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
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
                    _titleWidget("Хочу получить:"),
                    _dataShortInfoAbout(),
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
                  "Сохранить исправления",
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
    Exchange exchange = myExchange;
    if (dropdownValue != null) {
      if (myExchange.skill1 != dropdownValue ||
          myExchange.description != _desController.text) {
        formInfo.save();
        hideKeyboard();
        FocusScope.of(_context).unfocus();

        exchange.skill1 = dropdownValue;
        exchange.description = _des;

        if(inExc != null) {
          for (Exchange exc in inExc) {
            if ((exc.status == 0 || exc.status == 1) &&
                (exc.skill1 == exchange.skill1 && exc.skill2 == exchange.skill2 &&
                    exc.senderMail == exchange.senderMail &&
                    exc.receiverMail == exc.receiverMail)
                || (
                    exc.skill1 == exchange.skill2
                        && exc.skill2 == exchange.skill1
                        && exc.senderMail == exchange.receiverMail
                        && exc.receiverMail == exc.senderMail
                )) {
              if(exc.id != exchange.id) {
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
        }
        if(outExc != null) {
          for (Exchange exc in outExc) {
            if ((exc.status == 0 || exc.status == 1) &&
                (exc.skill1 == exchange.skill1 && exc.skill2 == exchange.skill2 &&
                    exc.senderMail == exchange.senderMail &&
                    exc.receiverMail == exc.receiverMail)
                || (
                    exc.skill1 == exchange.skill2
                        && exc.skill2 == exchange.skill1
                        && exc.senderMail == exchange.receiverMail
                        && exc.receiverMail == exc.senderMail
                )) {
              if(exc.id != exchange.id) {
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
        }
        if(curExc != null) {
          for (Exchange exc in curExc) {
            if ((exc.status == 0 || exc.status == 1) &&
                (exc.skill1 == exchange.skill1 && exc.skill2 == exchange.skill2 &&
                    exc.senderMail == exchange.senderMail &&
                    exc.receiverMail == exc.receiverMail)
                || (
                    exc.skill1 == exchange.skill2
                        && exc.skill2 == exchange.skill1
                        && exc.senderMail == exchange.receiverMail
                        && exc.receiverMail == exc.senderMail
                )) {
              if(exc.id != exchange.id) {
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
        }
        dialogLoading.show();
        Api.editExchange(exchange)
            .then((value) => {
                  if (value.isSuccess())
                    {
                      Api.getOutEx()
                          .then((value) => {
                                if (value.isSuccess())
                                  {
                                    dialogLoading.stop(),
                                    if(value.getData() != null)
                                    outExc = value.getData().reversed.toList(),
                                    Navigator.push(
                                        _context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new MyOutEx())),
                                  }
                                else
                                  {
                                    dialogLoading.stop(),
                                    Error.errorSnackBar(globalKey),
                                  }
                              })
                          .timeout(Duration(seconds: 90))
                          .catchError((Object object) => {
                                dialogLoading.stop(),
                                Error.errorSnackBar(globalKey)
                              }),
                    }
                  else
                    {
                      dialogLoading.stop(),
                      Error.errorSnackBar(globalKey),
                    }
                })
            .timeout(Duration(seconds: 90))
            .catchError((Object object) =>
                {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
      } else {
        Navigator.pop(_context);
      }
    }
  }

  void _perform() {
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
              image: (withWhom.photoUri == null ||
                  withWhom.photoUri.isEmpty)
                  ? null
                  : MemoryImage(withWhom
                      .photoUri), //MemoryImage(CurrentUser.profile.photoUri),
            )),
      ),
    );
  }

  void goToProfile() {

    // Navigator.push(
    //     _context,
    //     MaterialPageRoute(
    //         builder: (context) => NotMyProfile(profile: exchange.users[1])));
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
                        withWhom.name +
                            " " +
                            withWhom.surname,
                        style: TextStyle(
                          fontSize: 17.0,
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
                              exchange.skill2,
                              //controller: _emailController,
                            ))),
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

  var formKeyInfo = new GlobalKey<FormState>();

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

String dropdownValue;

class _MySkillState extends State<MySkill> {
  List<String> values = new List<String>();

  @override
  void initState() {
    super.initState();
    dropdownValue = myExchange.skill1;
    bool valEx = false;
    List<Skill> sk;
    if (myExchange.whoWantMail == CurrentUser.profile.email) {
      sk = CurrentUser.profile.skills
          .where((element) => element.status == 2)
          .toList();
    } else {
      sk = CurrentUser.profile.skills
          .where((element) => element.status == 1)
          .toList();
    }
    if (sk != null && sk.length > 0) {
      for (int i = 0; i < sk.length; i++) {
        values.add(sk[i].name);
        if (sk[i].name == dropdownValue) {
          valEx = true;
        }
      }
    }
    if (!valEx) {
      values.add(dropdownValue);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: values.length > 0
              ? DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  underline: Container(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              : new Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    myExchange.whoWantMail != CurrentUser.profile.email
                        ? "Сначала добавьте в профиле навыки,"
                            " которые хотели бы получить!"
                        : "Сначала добавьте в профиле навыки,"
                            " которыми могли бы поделиться!",
                    style: TextStyle(color: Colors.blue[600], fontSize: 14),
                  ))));
}
