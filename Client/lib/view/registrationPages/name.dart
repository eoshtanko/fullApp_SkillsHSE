import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/validators.dart';
import 'package:demoapp/view/registrationPages/birthday.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameReg extends StatefulWidget {
  @override
  _NameRegState createState() => _NameRegState();
}

class _NameRegState extends State<NameReg> {
  BuildContext _context;
  DialogLoading dialogLoading;
  final globalKey = GlobalKey<ScaffoldState>();
  var formNameKey = new GlobalKey<FormState>();
  var formSurnameKey = new GlobalKey<FormState>();
  String _name, _surname;

  @override
  void initState() {
    super.initState();
    formNameKey = new GlobalKey<FormState>();
    formSurnameKey = new GlobalKey<FormState>();
    _name = null;
    _surname = null;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    double height = MediaQuery.of(context).size.height;
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
              Container(height: height/7.3,),
              _dataArea(),
              buildIm(),
            ],
          )),
    );
  }

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
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        _titleArea(),
        _enterNameArea(),
        _enterSurnameArea(),
        enterButtonArea(_onPressed),
      ],
    ),
  );

  Widget _titleArea() => Container(
    margin: const EdgeInsets.only(left: 130, right: 130, top: 30),
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
      'Имя',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
    ),
  );

  Widget _enterNameArea() => Container(
    child: new Form(
      key: formNameKey,
      child: new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(
              top: 10,
                left: 8,
                right: 8
            ),
            child: new TextFormField(
              decoration: new InputDecoration(labelText: "Имя",
                  helperText: "Введите Ваше имя"),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
              autocorrect: false,
              onSaved: (val){
                CurrentUser.profile.surname = _surname;
              },
              onChanged: (val) {
                _name = val;
              },
              validator: (val) => !Validator.isValidNameOrSurname(val)
                  ? 'Некорректное имя'
                  : null,
            ),
            width: 370.0,
          ),
          //enterButtonArea(),
        ],
      ),
    ),
  );

  Widget _enterSurnameArea() => Container(
    child: new Form(
      key: formSurnameKey,
      child: new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(
              top: 10,
                left: 8,
                right: 8
            ),
            child: new TextFormField(
              decoration: new InputDecoration(labelText: "Фамилия",
                  helperText: "Введите Вашу фамилию"),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
              autocorrect: false,
              onSaved: (val){
                CurrentUser.profile.name = _name;
              },
              onChanged: (val) {
                _surname = val;
              },
              validator: (val) => !Validator.isValidNameOrSurname(val)
                  ? 'Некорректная фамилия'
                  : null,
            ),
            width: 370.0,
          ),
          //enterButtonArea(),
        ],
      ),
    ),
  );

  void _onPressed() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    if (formNameKey.currentState.validate() && formSurnameKey.currentState.validate()) {
      dialogLoading.show();
      Api.confirmNameAndSurname(_name, _surname)
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
                  "\n\n К сожалению, произошла ошибка.\n\n\n\n\n",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ))),
          }
      })
          .timeout(Duration(seconds: 90))
          .catchError(
              (Object object) => {dialogLoading.stop(), errorSnackBar()});
    }
  }

  void _submit() {
    final formName = formNameKey.currentState;
    final formSurname = formSurnameKey.currentState;
    if (formName.validate() && formSurname.validate()) {
      formName.save();
      formSurname.save();
      _goNext();
    }
  }

  void _goNext() {
    hideKeyboard();
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new BirthdayReg()));
  }

  void errorSnackBar() {
    globalKey.currentState.showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            duration: Duration(seconds: 5),
            content: Text(
              "\n\nПроизошла ошибка. Попробуйте повторить запрос позже.\n",
              style: TextStyle(fontSize: 20, color: Colors.blue),)));
  }
}
