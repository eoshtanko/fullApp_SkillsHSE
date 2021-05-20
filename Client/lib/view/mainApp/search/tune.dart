import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/search/search.dart';
import 'package:demoapp/view/mainApp/profile/addNewCan.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mainAppMap.dart';

String dropdownValueEduProgram;
String dropdownValueMainTune;
String dropdownValueSubTuneStudy;
String dropdownValueSubTuneNonStudy;
String dropdownValueStageOfEdu;
String dropdownValueSex;
String dropdownValueStatus;
String dropdownValueBuilding;
String dropdownValueDorm;

class Tuune extends StatefulWidget {
  @override
  Tune createState() => Tune();
}

DialogLoading dialogLoading;

class Tune extends State<Tuune> {
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    dropdownValueEduProgram = null;
    dropdownValueMainTune = null;
    dropdownValueSubTuneStudy = null;
    dropdownValueSubTuneNonStudy = null;
    dropdownValueStageOfEdu = null;
    dropdownValueSex = null;
    dropdownValueStatus = null;
    dropdownValueBuilding = null;
    dropdownValueDorm = null;
  }

  void _performLogin() {
    dialogLoading.show();
    int studyingYearId = -1;
    int majorId = -1;
    int campus = -1;
    int dorm = -1;
    int gender = -1;
    int category = -1;
    int subcategory = -1;
    int status = -1;
    if (dropdownValueStageOfEdu != null) {
      studyingYearId = stagesOfEdu.indexOf(dropdownValueStageOfEdu);
    }
    if (dropdownValueEduProgram != null) {
      majorId = eduPrograms.indexOf(dropdownValueEduProgram);
    }
    if (dropdownValueBuilding != null) {
      campus = buildings.indexOf(dropdownValueBuilding);
    }
    if (dropdownValueDorm != null) {
      dorm = dormitories.indexOf(dropdownValueDorm);
    }
    if (dropdownValueSex != null) {
      gender = sexes.indexOf(dropdownValueSex);
    }
    if (dropdownValueMainTune != null) {
      category = categories.indexOf(dropdownValueMainTune);
    }
    if (dropdownValueMainTune != null && (dropdownValueSubTuneStudy != null || dropdownValueSubTuneNonStudy != null)) {
      subcategory = categories == "Учеба"?
      subcategoriesStudy.indexOf(dropdownValueSubTuneStudy): subcategoriesNonStudy.indexOf(dropdownValueSubTuneNonStudy);
    }
    if (dropdownValueStatus != null) {
      status = statuses.indexOf(dropdownValueStatus) + 1;
    }

    Api.getSkillsByParam(studyingYearId, majorId, campus, dorm, gender,
            category, subcategory, status)
        .then((value) => {
              if (value.isSuccess())
                {
                  dialogLoading.stop(),
                  skills = value.getData(),
                  selectedIndex = 0,
                  Navigator.pushNamed(context, 'profileP'),
                }
              else
                {

                    dialogLoading.stop(),
                  Error.errorSnackBar(globalKey)
                }
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) => {  dialogLoading.stop(),  Error.errorSnackBar(globalKey)});
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Поиск по параметрам', style: TextStyle(color: Colors.blue)),
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
          child: new ListView(
            children: <Widget>[
              _dataArea(),
            ],
          )),
    );
  }

  bool mainTuneStudy = true;

  Widget _dataArea() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 30),
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
            _titleArea("Категория"),
            _dropDownMenuWidget(Container(
                child: DropdownButton<String>(
              isExpanded: true,
              hint: Text("Не выбрана"),
              value: dropdownValueMainTune,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 30,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 20),
              underline: Container(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValueMainTune = newValue;
                  mainTuneChanged = true;
                  if (newValue == '') {
                    mainTuneChanged = false;
                  } else {
                    if (newValue == 'Учеба') {
                      mainTuneStudy = true;
                    } else {
                      mainTuneStudy = false;
                    }
                  }
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ))),
            mainTuneChanged ? _titleArea("Подкатегория") : new Container(),
            mainTuneChanged
                ? _dropDownMenuWidget(Container(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: mainTuneStudy
                            ? dropdownValueSubTuneStudy
                            : dropdownValueSubTuneNonStudy,
                        icon: Icon(Icons.arrow_drop_down),
                        hint: Text("Не выбрана"),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        underline: Container(),
                        onChanged: (String newValue) {
                          setState(() {
                            if (mainTuneStudy) {
                              dropdownValueSubTuneStudy = newValue;
                              dropdownValueSubTuneNonStudy = null;
                            } else {
                              dropdownValueSubTuneNonStudy = newValue;
                              dropdownValueSubTuneStudy = null;
                            }
                          });
                        },
                        items: mainTuneStudy
                            ? subcategoriesStudy
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList()
                            : subcategoriesNonStudy
                                .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList())))
                : new Container(),
            _titleArea('Курс'),
            MyStageOfEdu(),
            _titleArea('Пол'),
            MySex(),
            _titleArea('Образовательная программа'),
            MyEduP(),
            _titleArea('Расположение корпуса'),
            MyBuild(),
            _titleArea('Общежитие'),
            MyDorm(),
            _titleArea('Может/Хочет'),
            MyStatus(),
            enterButtonArea(_performLogin),
          ],
        ),
      );

  bool mainTuneChanged = false;

  Widget _dropDownMenuWidget(Widget w) {
    return Container(
        margin: EdgeInsets.only(left: 35.0, right: 35.0, top: .0),
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    margin: EdgeInsets.only(left: 6.0, right: 6.0, top: 0.0),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: w,
                  )),
            ),
          ],
        ));
  }

  Widget _titleArea(String titleS) => Container(
        // alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(left: 0, right: 0, top: 30),
        padding: const EdgeInsets.all(10),
    width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          titleS,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      );
}

class MyStageOfEdu extends StatefulWidget {
  @override
  _MyStageOfEduState createState() => _MyStageOfEduState();
}

class _MyStageOfEduState extends State<MyStageOfEdu> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("Не выбран"),
            value: dropdownValueStageOfEdu,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueStageOfEdu = newValue;
              });
            },
            items: stagesOfEdu.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

class MySex extends StatefulWidget {
  @override
  _MySexState createState() => _MySexState();
}

class _MySexState extends State<MySex> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValueSex,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            hint: Text("Не выбран"),
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueSex = newValue;
              });
            },
            items: sexes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Widget enterButtonArea(void submit()) => MaterialButton(
      onPressed: submit,
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
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
          'Поиск',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );

class BrightnessSliderContainer extends StatefulWidget {
  @override
  _BrightnessSliderContainerState createState() =>
      _BrightnessSliderContainerState();
}

class _BrightnessSliderContainerState extends State<BrightnessSliderContainer> {
  double brightness = 0.0;
  var values = RangeValues(16, 40);

//RangeValues values = RangeValues(_lowerValue, _upperValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: RangeSlider(
          activeColor: Colors.blue,
          divisions: 24,
          min: 16,
          max: 40,
          values: values,
          labels: RangeLabels(
              values.start.toInt().toString(), values.end.toInt().toString()),
          onChanged: (RangeValues newRange) {
            setState(() => values = newRange);
          }),
    );
  }
}

class MyBuild extends StatefulWidget {
  @override
  _MyBuildState createState() => _MyBuildState();
}

class _MyBuildState extends State<MyBuild> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("Не выбрано"),
            value: dropdownValueBuilding,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueBuilding = newValue;
              });
            },
            items: buildings.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

class MyDorm extends StatefulWidget {
  @override
  _MyDormState createState() => _MyDormState();
}

class _MyDormState extends State<MyDorm> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text("Не выбрано"),
            value: dropdownValueDorm,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueDorm = newValue;
              });
            },
            items: dormitories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

class MyEduP extends StatefulWidget {
  @override
  _MyEduPState createState() => _MyEduPState();
}

class _MyEduPState extends State<MyEduP> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValueEduProgram,
            hint: Text("Не выбрана"),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            itemHeight: 75.0,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueEduProgram = newValue;
              });
            },
            items: eduPrograms.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}

class MyStatus extends StatefulWidget {
  @override
  _MyStatusState createState() => _MyStatusState();
}

class _MyStatusState extends State<MyStatus> {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 2, left: 35, right: 35),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValueStatus,
            hint: Text("Не выбран"),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(),
            onChanged: (String newValue) {
              setState(() {
                dropdownValueStatus = newValue;
              });
            },
            items: statuses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )));
}
