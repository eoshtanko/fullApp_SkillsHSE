import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/services.dart';
import 'package:demoapp/view/registrationPages/password.dart';
import 'name.dart';

class MyPassword2 extends StatefulWidget {
  @override
  MyPassword2State createState() => MyPassword2State();
}

class MyPassword2State extends State<MyPassword2> {
  String secondPassword;
  var formKey = new GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  BuildContext _context;

  @override
  void initState() {
    formKey = new GlobalKey<FormState>();
    super.initState();
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
        _context, new MaterialPageRoute(builder: (context) => new NameReg()));
  }

  DialogLoading dialogLoading;

  void _onPressed() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    if (formKey.currentState.validate()) {
      dialogLoading.show();
      Api.confirmPassword(secondPassword)
          .then((value) => {
        dialogLoading.stop(),
        if (value.isSuccess())
          {
            _submit(),
          }
        else
          {
            globalKey.currentState.showSnackBar(
                SnackBar(
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 3),
                    content: Text("\n\n К сожалению, произошла ошибка.\n\n\n\n\n",
                      style: TextStyle(fontSize: 20, color: Colors.blue),))),
          }
      })
          .timeout(Duration(seconds: 90))
          .catchError(
              (Object object) => {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: globalKey,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, false),
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
          child: ListView(
            children: <Widget>[
              Container(height: height/6.2,),
              _dataArea(),
              buildIm2(),
            ],
          )),
    );
  }

  Widget _titleArea() => Container(
    margin: const EdgeInsets.only(left: 60, right: 60, top: 30),
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
      'Повторите пароль',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
    ),
  );

  Widget _dataArea() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
    padding: const EdgeInsets.only(bottom: 30),
    width: 400,
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
        enterButtonArea(_onPressed),
      ],
    ),
  );

  Widget _enterArea() => Container(
    child: new Form(
      key: formKey,
      child: new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: new TextFormField(
              decoration: new InputDecoration(labelText: "Пароль",
                  helperText: "Повторите пароль"),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              maxLines: 1,
              onSaved: (val) =>  CurrentUser.profile.password = val,
              onChanged: (val) {
                secondPassword = val;
              },
              validator: (val) => (password != val)
                  ? 'Пароль не совпадает.'
                  : null,
            ),
            width: 305.0,
          ),
        ],
      ),
    ),
  );
}
