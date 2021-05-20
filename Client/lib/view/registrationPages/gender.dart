import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/registrationPages/stageOfEdu.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';

class GenderReg extends StatelessWidget {
  BuildContext _context;
  DialogLoading dialogLoading;
  final formKey = new GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  int _gender;

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
          color: Colors.blue,
          onPressed: () => Navigator.pop(context, false),
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
              Container(height: height/5.3,),
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
      // BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        _enterArea(),
      ],
    ),
  );

  Widget _enterArea() => Container(
    child: new Form(
      key: formKey,
      child: new Column(
        children: <Widget>[
          _titleArea(),
          _enterButtonAreaMale(),
          _enterButtonAreaFemale(),
        ],
      ),
    ),
  );

  Widget _titleArea() => Container(
    // alignment: Alignment.bottomCenter,
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
      'Пол',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
    ),
  );

  Widget _enterButtonAreaFemale() => MaterialButton(
    onPressed: (){
      _gender = 1;
      _onPressed();
    },
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      padding: const EdgeInsets.all(10),
      width: 400,
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
        'Женский',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  );

  Widget _enterButtonAreaMale() => MaterialButton(
    onPressed: (){
      _gender = 0;
      _onPressed();
    },
    child: Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      padding: const EdgeInsets.all(10),
      width: 400,
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
        'Мужской',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  );

  void _onPressed() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    if (_gender == 0 || _gender == 1) {
      dialogLoading.show();
      Api.confirmSex(_gender)
          .then((value) => {
        dialogLoading.stop(),
        if (value.isSuccess())
          {
            CurrentUser.profile.gender = _gender,
            _goNext(),
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

  void _goNext() {
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new StageOfEduReg()));
  }

  void errorSnackBar() {
    globalKey.currentState.showSnackBar(
        SnackBar(
            backgroundColor: Colors.white,
            duration: Duration(seconds: 5),
            content: Text(
              "\n\nПроизошла ошибка. Попробуйте повторить запрос позже.\n\n\n\n\n",
              style: TextStyle(fontSize: 20, color: Colors.blue),)));
  }
}
