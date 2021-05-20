import 'dart:async';

import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/validators.dart';
import 'package:demoapp/view/registrationPages/key.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Email extends StatefulWidget {
  @override
  EmailState createState() => EmailState();
}

class EmailState extends State<Email> {
  final globalKey = GlobalKey<ScaffoldState>();
  var formKey = new GlobalKey<FormState>();

  BuildContext _context;
  bool _block = false;
  DateTime _blockTime;
  String email;
  int count = 0;

  @override
  void initState() {
    formKey = new GlobalKey<FormState>();
    email = null;
    _block = false;
    count = 0;
  }

  void timer(){
    Timer(Duration(seconds: 3), () {

    });
  }

  void _onPressed() {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    final form = formKey.currentState;

    if (form.validate()) {
      dialogLoading.show();
      form.save();
      Api.sendCode(email.toLowerCase())
          .then((value) =>
      {
        dialogLoading.stop(),
        if (value.statusCode == 200 || value.statusCode == 201)
          {
            _performLogin()
          }
        else
          {
            hideKeyboard(),
            globalKey.currentState.showSnackBar(
                SnackBar(
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 3),
                    content: Text("\n\n${value.message}\n\n\n\n\n",
                      style: TextStyle(fontSize: 20, color: Colors.blue),))),
          },
      })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
      {
        dialogLoading.stop(),
        Error.errorSnackBar(globalKey)
      });
    }
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _performLogin();
    }
  }

  void _performLogin() {
    hideKeyboard();
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new MyKey()));
  }

  DialogLoading dialogLoading;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, false),
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
      ),

      resizeToAvoidBottomPadding: false,
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            image: DecorationImage(
              image: AssetImage('assets/images/фон.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Container(height: height/6.5,),
                  new Container(child:
                  _dataArea(),    width: 400,),
              buildIm(),
            ],
          )),
    );
  }

  Widget _dataArea() =>
      Container(
        width: 400,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        padding: const EdgeInsets.only(bottom: 30),
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
            _titleArea(),
            _enterArea(),
            //enterButtonArea(_submit)
            enterButtonArea(_onPressed),
          ],
        ),
      );

  Widget _titleArea() =>
      Container(
        margin: const EdgeInsets.only(left: 90, right: 90, top: 30),
        padding: const EdgeInsets.all(10),
        width: 400,
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
          'Почта @edu.hse.ru',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  Widget _enterArea() =>
      Container(
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 8,
                  right: 8
                ),
                child: new TextFormField(
                  decoration: new InputDecoration(labelText: "Email",
                      helperText: "Введите @edu.hse.ru почту"),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  onSaved: (value) {
                    //Profile.setEmail = val;
                    email = value.trim();
                  },
                  onChanged: (String value) {
                    email = value.trim();
                  },
                  validator: (val) =>
                  (!Validator.isValidEmail(val))
                      ? 'Некорректный email.'
                      : null,
                ),
                width: 370.0,
              ),
            ],
          ),
        ),
      );
}
