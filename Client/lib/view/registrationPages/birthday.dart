import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/gender.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BirthdayReg extends StatefulWidget {
  @override
  _BirthdayRegState createState() => _BirthdayRegState();
}

class _BirthdayRegState extends State<BirthdayReg> {
  BuildContext _context;
  DialogLoading dialogLoading;
  final globalKey = GlobalKey<ScaffoldState>();
  DateTime _chosenDateTime;
  bool _wrongData = false;

  @override
  void initState() {
    super.initState();
    _chosenDateTime = null;
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
              _dataArea(),
              buildIm2(),
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
            _titleArea(),
            _enterArea(),
            enterButtonArea(_onPressed),
          ],
        ),
      );

  Widget _titleArea() => Container(
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
          "Дата рождения",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  Widget _enterArea() => Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: CupertinoButton(
          padding: EdgeInsetsDirectional.zero,
          child: Text(
            _chosenDateTime != null
                ? ("День: " +
                        _chosenDateTime.day.toString() +
                        // "." +
                        " Месяц: " +
                        _chosenDateTime.month.toString() +
                        //  "." +
                        " Год: " +
                        _chosenDateTime.year.toString()) +
                    ""
                : 'Выбрать дату',
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: _wrongData ? Colors.red : Colors.amber),
          ),
          onPressed: () => _showDatePicker(context),
        ),
      );

  void _showDatePicker(ctx) {
    DateTime curData = DateTime.now();
    DateTime initialData = DateTime(2000, 1, 1);
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        maximumYear: curData.year - 13,
                        minimumYear: curData.year - 100,
                        initialDateTime: initialData,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        if (_chosenDateTime == null) {
                          _chosenDateTime = initialData;
                        }
                        _wrongData = false;
                      });
                    },
                  )
                ],
              ),
            ));
  }

  void _submit() {
    if (_chosenDateTime != null) {
      CurrentUser.profile.birthday = _chosenDateTime;
      _goNext();
    } else {
      setState(() {
        _wrongData = true;
      });
    }
  }

  void _onPressed() async {
    hideKeyboard();
    FocusScope.of(_context).unfocus();
    if (_chosenDateTime != null) {
      dialogLoading.show();
      Api.confirmDateOfBirthday(_chosenDateTime)
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

  void _goNext() {
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new GenderReg()));
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
