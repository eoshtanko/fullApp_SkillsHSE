import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/logic/CurrentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/campus.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';

String dropdownValue;
bool eduProgramIsPresent = true;

class EduProgramReg extends StatefulWidget {
  @override
  _EduProgramRegState createState() => _EduProgramRegState();
}

class _EduProgramRegState extends State<EduProgramReg> {
  BuildContext _context;
  DialogLoading dialogLoading;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dropdownValue = null;
    eduProgramIsPresent = true;
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
          color: Colors.blue,
          onPressed: () => Navigator.pop(context, false),
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
              Container(height: height/6.6,),
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
            dropDownMenu(dropdownValue, eduProgramIsPresent, "Не выбрана",
                _onChange, eduPrograms, 75),
            enterButtonArea(_onPressed),
          ],
        ),
      );

  Widget _titleArea() => Container(
        margin: const EdgeInsets.only(left: 39, right: 39, top: 30),
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
          'Образовательная программа',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  void _onChange(String newValue) {
    setState(() {
      eduProgramIsPresent = true;
      dropdownValue = newValue;
    });
  }

  void _onPressed() async {
    if(CurrentUser.profile != null) {
      print(dropdownValue == null);
    }
    if (dropdownValue != null) {
      FocusScope.of(_context).unfocus();
      dialogLoading.show();
      Api.confirmEduProgram(eduPrograms.indexOf(dropdownValue))
          .then((value) => {
                dialogLoading.stop(),
                if (value.isSuccess())
                  {
                    _goNext(),
                  }
                else
                  {
                    errorSnackBar()
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError(
              (Object object) => {dialogLoading.stop(), errorSnackBar()});
    } else{
      setState(() {
        eduProgramIsPresent = false;
      });
    }
  }

  void _goNext() {
    Navigator.push(
        _context, new MaterialPageRoute(builder: (context) => new CampusReg()));
  }

  void errorSnackBar() {
    globalKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 5),
        content: Text(
          "\n\nПроизошла ошибка. Попробуйте повторить запрос позже.\n\n\n\n\n",
          style: TextStyle(fontSize: 20, color: Colors.blue),
        )));
  }
}
