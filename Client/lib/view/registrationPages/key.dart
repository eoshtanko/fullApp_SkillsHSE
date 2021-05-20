import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/password.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/services.dart';
import 'package:demoapp/view/widgets/dialog.dart';

int keyFromEmail;

class MyKey extends StatefulWidget {
  @override
  MyKeyState createState() => MyKeyState();
}

class MyKeyState extends State<MyKey> {
  final globalKey = GlobalKey<ScaffoldState>();
  var formKey = new GlobalKey<FormState>();
  int count;
  BuildContext _context;
  int code;

  @override
  void initState() {
    formKey = new GlobalKey<FormState>();
    code = null;
    count = 0;
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _performLogin();
    }
  }

  DialogLoading dialogLoading;

  void _onPressed() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    if (formKey.currentState.validate()) {
      dialogLoading.show();
      Api.confirmCode(code)
          .then((value) => {
                dialogLoading.stop(),
                if (value.isSuccess())
                  {
                    _submit(),
                  }
                else
                  {
                    globalKey.currentState.showSnackBar(SnackBar(
                        backgroundColor: Colors.white,
                        duration: Duration(seconds: 3),
                        content: Text(
                          "\n\n К сожалению, код неверный или произошла ошибка.\n\n\n\n\n",
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ))),
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError(
              (Object object) => {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    }
  }

  void _performLogin() {
    Navigator.push(_context,
        new MaterialPageRoute(builder: (context) => new MyPassword()));
  }

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
              Container(height: height/6.0,),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
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
              ),
              buildIm2(),
            ],
          )),
    );
  }

  Widget _titleArea() => Container(
        // alignment: Alignment.bottomCenter,
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
          'Код подтверждения',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
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
                  decoration: new InputDecoration(
                      labelText: "Код из письма",
                      helperText: "Введите код с почты"),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  onSaved: (val) {
                    CurrentUser.profile.confirmationCodeUser = code;
                    CurrentUser.profile.confirmationCodeServer = code;
                  },
                  onChanged: (val) {
                    code = int.tryParse(val);
                  },
                  validator: (val) =>
                      (val.length != 4)
                          ? 'Некорректный код.'
                          : null,
                ),
                width: 200.0,
              ),
            ],
          ),
        ),
      );
}
