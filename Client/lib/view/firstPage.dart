import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/mainAppMap.dart';
import 'package:demoapp/view/passwordRecovery/emailRec.dart';
import 'package:demoapp/view/registrationPages/campus.dart';
import 'package:demoapp/view/registrationPages/eduProgram.dart';
import 'package:demoapp/view/registrationPages/email.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/logic/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class EnterPage extends StatefulWidget{
  @override
  EnterPageState createState() => EnterPageState();
}

class EnterPageState  extends State<EnterPage> {
  BuildContext _context;
  DialogLoading dialogLoading;
  var formKey = new GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    formKey = new GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: globalKey,
        resizeToAvoidBottomPadding: false,
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/фон.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: <Widget>[
                Container(height: height/15,),
                colomn(height),
              ],
            )),
      ),
    );
  }

  Widget colomn(height){
    return Column(
      children: <Widget>[
        _buildTopIm(),
        _enterArea(),
        new Container(child:_enterButtonArea(), width: 400.0,),
        Container(height: height/65,),
        new Container(child:_registrationButtonArea(), width: 400.0,),
        Container(height: height/30,),
        new Container(child:_recoveryButtonArea(), width: 400.0,)
      ],
    );
  }

  Widget buttonArea(void action(), String txt) => MaterialButton(
      onPressed: (){
        action();
      },
      child: Container(
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
            color: Colors.white,
          ),
          child: Text(
            txt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          )
    ),
  );

  Widget _recoveryButtonArea() => Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: buttonArea(_performRecovery, 'Восстановление пароля')
      );

  Widget _enterButtonArea() => Container(
        margin: const EdgeInsets.only(left: 5, right: 5, top: 20,
        ),
        child: buttonArea(_performEnter, 'Вход')
      );

  Widget _registrationButtonArea() => Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child:   buttonArea(_performReg, 'Регистрация')
      );

  Widget _enterArea() => Container(
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(left: 23, right: 23),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      labelText: "Email",
                      helperText: "Введите @edu.hse.ru почту"),
                  controller: _emailController,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  onSaved: (val) => _email = val,
                  validator: (val) =>
                      !Validator.isValidEmail(val) ? 'Некорректная почта' : null,
                ),
                width: 400.0,
              ),
              new Container(
                margin: const EdgeInsets.only(left: 23, right: 23),
                child: new TextFormField(
                  decoration: new InputDecoration(
                      labelText: "Пароль", helperText: "Введите пароль"),
                  obscureText: true,
                  maxLines: 1,
                  controller: _passwordController,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (val) =>
                      !Validator.isValidPassword(val) ? 'Некорректный пароль' : null,
                  onSaved: (val) => _password = val,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                width: 400.0,
                //padding: new EdgeInsets.only(top: 38.0),
              ),
            ],
          ),
        ),
      );

  Widget _buildTopIm() => Container(
        margin: const EdgeInsets.only(top: 22, bottom: 15),
        child: Image.asset(
          'assets/images/11.png',
        ),
      );

  void _performEnter() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      dialogLoading.show();
      Api.confirmEntre(_email, _password)
          .then((value) => {
        if (value == null)
          {
            dialogLoading.stop(),
            globalKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 3),
                content: Text(
                  "\n\n Пароль или логин неверны.\n\n\n\n\n",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ))),
          } else if (value.isSuccess())
          {
            dialogLoading.stop(),
            enter(),
          }
        else
          {
            dialogLoading.stop(),
            Error.errorSnackBar(globalKey)
          }
      })
          .timeout(Duration(seconds: 90))
          .catchError(
              (Object object) => {
                dialogLoading.stop(),
                Error.errorSnackBar(globalKey)});
    }
  }

  void _performReg() {
    clear();
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new Email()));
  }

  void _performRecovery() async {
    clear();
    final result = await Navigator.push(_context,
        new MaterialPageRoute(builder: (context) => new EmailForRecovery()));
    if(result == 1) {
      globalKey.currentState.showSnackBar(
          SnackBar(
              backgroundColor: Colors.white,
              duration: Duration(seconds: 5),
              content: Text(
                "\n\nНа Вашу почту пришло сообщение, содержащие пароль.\n\n\n\n\n",
                style: TextStyle(fontSize: 20, color: Colors.blue),)));
    }
  }

  void enter() {
    clear();
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new MainApp()));
  }

  void clear(){
    hideKeyboard();
    formKey = new GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    setState(() {});
  }
}
