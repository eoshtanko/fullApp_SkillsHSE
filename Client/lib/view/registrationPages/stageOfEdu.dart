import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/registrationPages/tools.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';

import 'eduProgram.dart';

String dropdownValue;
bool stageIsPresent = true;

class StageOfEduReg extends StatefulWidget {
  @override
  _StageOfEduRegState createState() => _StageOfEduRegState();
}

class _StageOfEduRegState extends State<StageOfEduReg> {
  BuildContext _context;
  DialogLoading dialogLoading;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    stageIsPresent = true;
    dropdownValue = null;
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
              Container(height: height/5.8,),
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
            dropDownMenu(dropdownValue, stageIsPresent, "Не выбран", _onChange,
                stagesOfEdu, 0),
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
          'Курс',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      );

  void _onChange(String newValue) {
    setState(() {
      stageIsPresent = true;
      dropdownValue = newValue;
    });
  }

  void _onPressed() async {
    if (dropdownValue != null) {
      FocusScope.of(_context).unfocus();
      dialogLoading.show();
      Api.confirmStageOfEdu(stagesOfEdu.indexOf(dropdownValue))
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
    } else {
      setState(() {
        stageIsPresent = false;
      });
    }
  }

  void _goNext() {
    Navigator.push(_context,
        new MaterialPageRoute(builder: (context) => new EduProgramReg()));
  }

  void callSnackBar(String text) {}

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
