import 'dart:io';
import 'dart:ui';

import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/validators.dart';
import 'package:demoapp/view/mainApp/exchanges/completedEx.dart';
import 'package:demoapp/view/mainApp/exchanges/currentEx.dart';
import 'package:demoapp/view/mainApp/exchanges/inEx.dart';
import 'package:demoapp/view/mainApp/exchanges/outEx.dart';
import 'package:demoapp/view/mainApp/profile/want.dart';
import 'package:demoapp/view/mainApp/profile/can.dart';
import 'package:demoapp/view/mainApp/search/search.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'can.dart';
import '../../widgets/dialog.dart';

final _emailController = TextEditingController();
final _nameController = TextEditingController();
final _surnameController = TextEditingController();
final _ageController = TextEditingController();
final _sexController = TextEditingController();
var _socialNetworkController = TextEditingController();
var _aboutMeController = TextEditingController();

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _emailController.text = CurrentUser.profile.email;
    _nameController.text = CurrentUser.profile.name;
    _surnameController.text = CurrentUser.profile.surname;
    _ageController.text = CurrentUser.profile.birthday.toString();
    _sexController.text = sexes[CurrentUser.profile.gender];
    _socialNetworkController.text = CurrentUser.profile.socialNetwork;
    _aboutMeController.text = CurrentUser.profile.aboutMe;

    return Scaffold(
      appBar: null,
      body: new ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  Image im;
  String name, surname, socialM, aboutMe;
  String dropdownValueEduP = eduPrograms[CurrentUser.profile.eduProgram];
  String dropdownValueStageOfEdu = stagesOfEdu[CurrentUser.profile.stageOfEdu];
  String dropdownValueDorm = dormitories[CurrentUser.profile.dormitory];
  String dropdownValueBuild = buildings[CurrentUser.profile.campus];
  String dropdownValueSex = sexes[CurrentUser.profile.gender];
  ImageProvider<Object> imageProvider = (CurrentUser.profile.photoUri == null ||
          CurrentUser.profile.photoUri.isEmpty)
      ? null
      : MemoryImage(CurrentUser.profile.photoUri);

  @override
  void initState() {
    name = null; surname = null; socialM = null; aboutMe = null; _password = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (CurrentUser.profile == null) {
      CurrentUser.profile = new Profile();
    }
    imageProvider = (CurrentUser.profile.photoUri == null ||
            CurrentUser.profile.photoUri.isEmpty)
        ? null
        : MemoryImage(CurrentUser.profile.photoUri);
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
          key: globalKey,
          appBar: AppBar(
            leading: new Container(),
            backgroundColor: Colors.white,
            title: Text('Мой профиль', style: TextStyle(color: Colors.blue)),
            elevation: 1.0,
          ),
          body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 180.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            //todo
                            child: new Stack(fit: StackFit.loose, children: <
                                Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  (CurrentUser.profile.photoUri == null ||
                                          CurrentUser.profile.photoUri.isEmpty)
                                      ? new Container(
                                          width: 150.0,
                                          height: 150.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                image: new ExactAssetImage(
                                                    'assets/images/88.png'),
                                                fit: BoxFit.cover,
                                              )),
                                        )
                                      : new Container(
                                          width: 150.0,
                                          height: 150.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    imageProvider, //MemoryImage(CurrentUser.profile.photoUri),
                                              )),
                                          //child: Imm(),
                                        )
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 97.0, right: 120.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new GestureDetector(
                                          onTap: onTap,
                                          child: new CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              radius: 25.0,
                                              child: _getCameraIcon()))
                                    ],
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 13.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Мои данные',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status
                                            ? _getEditIcon()
                                            : new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            _buttonArea(_performCan, 'Могу'),
                            _buttonArea(_performWant, 'Хочу'),
                            _titleWidget('Имя'),
                            _enterNameArea(),
                            _titleWidget('Фамилия'),
                            _enterSurnameArea(),
                            _titleWidget('Email'),
                            _enterEmailArea(),
                            _titleWidget('Социальная сеть'),
                            _enterSocialNetwork(),
                            _titleWidget('Обо мне'),
                            _dataInfoAboutMe(),
                            _titleWidget('Образовательная программа'),
                            _dropDownMenuWidget(Container(
                                child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueEduP,
                              icon: _status
                                  ? Icon(null)
                                  : Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(),
                              disabledHint: Text(
                                dropdownValueEduP,
                                style: TextStyle(color: Colors.black),
                              ),
                              onChanged: !_status
                                  ? (String newValue) {
                                      setState(() {
                                        dropdownValueEduP = newValue;
                                        eduProgChanged = true;
                                      });
                                    }
                                  : null,
                              items: eduPrograms.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                            ))),
                            _titleWidget('Общежитие'),
                            _dropDownMenuWidget(DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueDorm,
                              icon: _status
                                  ? Icon(null)
                                  : Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(),
                              disabledHint: Text(
                                dropdownValueDorm,
                                style: TextStyle(color: Colors.black),
                              ),
                              onChanged: !_status
                                  ? (String newValue) {
                                      setState(() {
                                        dropdownValueDorm = newValue;
                                        dormChanged = true;
                                      });
                                    }
                                  : null,
                              items: dormitories.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                            _titleWidget('Ступень обучения'),
                            _dropDownMenuWidget(DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueStageOfEdu,
                              icon: _status
                                  ? Icon(null)
                                  : Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(),
                              disabledHint: Text(
                                dropdownValueStageOfEdu,
                                style: TextStyle(color: Colors.black),
                              ),
                              onChanged: !_status
                                  ? (String newValue) {
                                      setState(() {
                                        dropdownValueStageOfEdu = newValue;
                                        eduYearChanged = true;
                                      });
                                    }
                                  : null,
                              items: stagesOfEdu.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                            _titleWidget('Расположение корпуса'),
                            _dropDownMenuWidget(DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueBuild,
                              icon: _status
                                  ? Icon(null)
                                  : Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(),
                              disabledHint: Text(
                                dropdownValueBuild,
                                style: TextStyle(color: Colors.black),
                              ),
                              onChanged: !_status
                                  ? (String newValue) {
                                      setState(() {
                                        dropdownValueBuild = newValue;
                                        buildingChanged = true;
                                      });
                                    }
                                  : null,
                              items: buildings.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                            _titleWidget('Пол'),
                            _dropDownMenuWidget(DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValueSex,
                              icon: _status
                                  ? Icon(null)
                                  : Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 16,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              underline: Container(),
                              disabledHint: Text(
                                dropdownValueSex,
                                style: TextStyle(color: Colors.black),
                              ),
                              onChanged: !_status
                                  ? (String newValue) {
                                      setState(() {
                                        dropdownValueSex = newValue;
                                        sexChanged = true;
                                      });
                                    }
                                  : null,
                              items: sexes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                            _titleWidget('Дата рождения'),
                            _showAgeArea(),
                            !_status
                                ? _titleWidget('Изменение пароля')
                                : new Container(),
                            !_status ? _enterPasswordArea() : new Container(),
                            !_status
                                ? _enterPasswordRepArea()
                                : new Container(),
                            _status ? _buttonLogOutArea() : new Container(),
                            !_status ? _saveButtons() : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  DateTime _chosenDateTime = CurrentUser.profile.birthday;

  Widget _showAgeArea() => Container(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Flexible(
            child: Container(
                margin: const EdgeInsets.only(top: 14, left: 0, right: 0),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  child: !_status
                      ? CupertinoButton(
                          padding: EdgeInsetsDirectional.zero,
                          child: Center(
                            child: Text(
                              _chosenDateTime != null
                                  ? ("День: " +
                                          _chosenDateTime.day.toString() +
                                          " " +
                                          " Месяц: " +
                                          _chosenDateTime.month.toString() +
                                          " " +
                                          " Год: " +
                                          _chosenDateTime.year.toString()) +
                                      ""
                                  : 'Выбрать дату',
                              style: TextStyle(
                                  //fontSize: 24,
                                  fontSize: 16.0,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          onPressed: () =>
                              !_status ? _showDatePicker(context) : null,
                        )
                      : Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: Text(
                              _chosenDateTime != null
                                  ? ("День: " +
                                          _chosenDateTime.day.toString() +
                                          " " +
                                          " Месяц: " +
                                          _chosenDateTime.month.toString() +
                                          " " +
                                          " Год: " +
                                          _chosenDateTime.year.toString()) +
                                      ""
                                  : 'Выбрать дату',
                              style: TextStyle(
                                  //fontSize: 24,
                                  fontSize: 16.0,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                )),
          ),
        ],
      ));

  void _showDatePicker(ctx) {
    DateTime curData = DateTime.now();
    DateTime initialData = CurrentUser.profile.birthday;
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
                            // todo change
                            CurrentUser.profile.birthday = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text(
                      'OK',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_chosenDateTime == null) {
                          _chosenDateTime = initialData;
                        }
                        Navigator.of(context).pop(_chosenDateTime);
                      });
                    },
                  )
                ],
              ),
            ));
  }

  bool trueName = true;
  final formKeyName = new GlobalKey<FormState>();

  Widget _enterNameArea() => Container(
        child: new Form(
          key: formKeyName,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText: !_status ? "Введите Ваше имя" : null),
                    style: TextStyle(
                      color: trueName ? Colors.black : Colors.red,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      if (Validator.isValidNameOrSurname(val)) {
                        setState(() {
                          name = val;
                          trueName = true;
                        });
                      } else {
                        setState(() {
                          trueName = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: !_status,
                    onSaved: (val) {
                      if (Validator.isValidNameOrSurname(val)) {
                        CurrentUser.profile.name = val;
                      }
                    },
                    controller: _nameController,
                    validator: (val) => (!Validator.isValidNameOrSurname(val))
                        ? 'Некорректное имя.'
                        : null,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  bool trueSurname = true;
  final formKeySurname = new GlobalKey<FormState>();

  Widget _enterSurnameArea() => Container(
        child: new Form(
          key: formKeySurname,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText: !_status ? "Введите Вашу фамилию" : null),
                    style: TextStyle(
                      color: trueSurname ? Colors.black : Colors.red,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      if (Validator.isValidNameOrSurname(val)) {
                        setState(() {
                          surname = val;
                          trueSurname = true;
                        });
                      } else {
                        setState(() {
                          trueSurname = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: !_status,
                    onSaved: (val) {
                      if (Validator.isValidNameOrSurname(val)) {
                        CurrentUser.profile.surname = val;
                      }
                    },
                    controller: _surnameController,
                    validator: (val) => (!Validator.isValidNameOrSurname(val))
                        ? 'Некорректная фамилия.'
                        : null,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  bool trueEmail = true;
  final formKeyEmail = new GlobalKey<FormState>();

  Widget _enterEmailArea() => Container(
        child: new Form(
          key: formKeyEmail,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText:
                            !_status ? "Введите @edu.hse.ru почту" : null),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      if (Validator.isValidEmail(val)) {
                        setState(() {
                          trueEmail = true;
                        });
                      } else {
                        setState(() {
                          trueEmail = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: false,
                    onSaved: (val) {
                      if (Validator.isValidEmail(val)) {
                        CurrentUser.profile.email = val;
                      }
                    },
                    controller: _emailController,
                    validator: (val) => (!Validator.isValidEmail(val))
                        ? 'Некорректный email.'
                        : null,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  bool trueSocialNetwork = true;
  bool contactChanged = false;
  final formKeyVk = new GlobalKey<FormState>();

  Widget _enterSocialNetwork() => Container(
        child: new Form(
          key: formKeyVk,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText: !_status
                            ? "vk.com/ или t.me/ + Ваш контакт"
                            : null),
                    style: TextStyle(
                      color: trueSocialNetwork ? Colors.black : Colors.red,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      contactChanged = true;
                      if ((val.length < 17) &&
                          (val.startsWith("vk.com/") ||
                              val.startsWith("t.me/"))) {
                        //todo empty string
                        setState(() {
                          socialM = val;
                          trueSocialNetwork = true;
                        });
                      } else {
                        setState(() {
                          trueSocialNetwork = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: !_status,
                    controller: _socialNetworkController,
                    validator: (val) => (((val.length < 17) &&
                                (val.startsWith("vk.com/") ||
                                    val.startsWith("t.me/"))) ||
                            contactChanged == false ||
                            val == null ||
                            val == "")
                        ? null
                        : 'Некорректная ссылка. vk.com/ или t.me/ + Ваш контакт',
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  bool truePassword = true;
  bool passwordChanged = false;
  final formKeyPassword = new GlobalKey<FormState>();
  String _password;

  Widget _enterPasswordArea() => Container(
        child: new Form(
          key: formKeyPassword,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText: !_status ? "Введите Новый Пароль" : null),
                    style: TextStyle(
                      color: truePassword ? Colors.black : Colors.red,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      passwordChanged = true;
                      if (Validator.isValidPassword(val)) {
                        setState(() {
                          truePassword = true;
                          _password = val;
                        });
                      } else {
                        setState(() {
                          _password = val;
                          truePassword = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: !_status,
                    onSaved: (val) {
                      if (Validator.isValidPassword(val)) {
                        _password = val;
                      }
                    },
                    validator: (val) =>
                    !(Validator.isValidPassword(val) ||
                            passwordChanged == false ||
                        val == null ||
                        val.isEmpty)
                        ? 'Некорректный пароль.'
                        : null,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  bool truePasswordRep = true;
  final formKeyPasswordRep = new GlobalKey<FormState>();

  Widget _enterPasswordRepArea() => Container(
        child: new Form(
          key: formKeyPasswordRep,
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                        helperText: !_status ? "Повторите Новый Пароль" : null),
                    style: TextStyle(
                      color: truePasswordRep ? Colors.black : Colors.red,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    onChanged: (val) {
                      if (val == _password) {
                        setState(() {
                          truePasswordRep = true;
                        });
                      } else {
                        setState(() {
                          truePasswordRep = false;
                        });
                      }
                    },
                    autocorrect: false,
                    enabled: !_status,
                    onSaved: (val) {
                      if (val == _password) {
                        CurrentUser.profile.password = val;
                      }
                    },
                    validator: (val) =>
                        !(val == _password || passwordChanged == false ||
                            ((_password == null || _password.isEmpty) && (val == null || val.isEmpty)))
                            ? 'Пароли не совпадают.'
                            : null,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  Widget _dataInfoAboutMe() {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Padding(
                padding: !_status? EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0):
                EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: !_status
                          ? Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText:
                                        "Расскажите о себе (не более 200 знаков)"),
                                maxLength: 200,
                                controller: _aboutMeController,
                                keyboardType: TextInputType.text,
                                maxLengthEnforced: true,
                                maxLines: 7,
                                onChanged: (val){
                                  aboutMe = val;
                                },
                                enabled: !_status,
                                //controller: _emailController,
                              ))
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: new Text(
                                _aboutMeController.text,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                    ),
                  ],
                ))));
  }

  Widget _dropDownMenuWidget(Widget w) {
    return Container(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: Container(
                  margin: const EdgeInsets.only(top: 14),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    child: w,
                  )),
            ),
          ],
        ));
  }

  Widget _titleWidget(String tit) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  tit,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _saveButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Сохранить"),
                textColor: Colors.white,
                color: Colors.blue[300],
                onPressed: _onPressed,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  bool sexChanged = false;
  bool dormChanged = false;
  bool buildingChanged = false;
  bool eduProgChanged = false;
  bool eduYearChanged = false;

  DialogLoading dialogLoading;
  BuildContext _context;
  final globalKey = GlobalKey<ScaffoldState>();

  void _onPressed() async {
    hideKeyboard();
    final formName = formKeyName.currentState;
    final formSurname = formKeySurname.currentState;
    final formSocialNetwork = formKeyVk.currentState;
    final formPassword2 = formKeyPassword.currentState;
    final formPassword = formKeyPasswordRep.currentState;
    FocusScope.of(_context).unfocus();
    if (formName.validate() &&
        formSurname.validate() &&
        formSocialNetwork.validate() &&
        formPassword2.validate() &&
        formPassword.validate()) {
      if ((name != null && name != CurrentUser.profile.name) ||
          (surname != null && surname != CurrentUser.profile.surname) ||
          (socialM != null &&
              socialM !=
                  CurrentUser.profile.socialNetwork) ||
          (aboutMe != null &&
              aboutMe != CurrentUser.profile.aboutMe) ||
          (dropdownValueEduP != null &&
              eduPrograms.indexOf(dropdownValueEduP) !=
                  CurrentUser.profile.eduProgram) ||
          (dropdownValueDorm != null &&
              dormitories.indexOf(dropdownValueDorm) !=
                  CurrentUser.profile.dormitory) ||
          (dropdownValueStageOfEdu != null &&
              stagesOfEdu.indexOf(dropdownValueStageOfEdu) !=
                  CurrentUser.profile.stageOfEdu) ||
          (dropdownValueBuild != null &&
              buildings.indexOf(dropdownValueBuild) !=
                  CurrentUser.profile.campus) ||
          (dropdownValueSex != null &&
              sexes.indexOf(dropdownValueSex) != CurrentUser.profile.gender) ||
          (_chosenDateTime != null &&
              _chosenDateTime != CurrentUser.profile.birthday) ||
          (_password != null && _password.isNotEmpty && _password != CurrentUser.profile.password)) {
        Profile p = CurrentUser.profile;
        p.gender = sexes.indexOf(dropdownValueSex);
        p.dormitory = dormitories.indexOf(dropdownValueDorm);
        p.campus = buildings.indexOf(dropdownValueBuild);
        p.eduProgram = eduPrograms.indexOf(dropdownValueEduP);
        p.stageOfEdu = stagesOfEdu.indexOf(dropdownValueStageOfEdu);
        p.aboutMe = _aboutMeController.text;
        if (name != null) {
          p.name = name;
        } else {
          p.name = CurrentUser.profile.name;
        }
        if (surname != null) {
          p.surname = surname;
        } else {
          p.surname = CurrentUser.profile.surname;
        }
        if (_socialNetworkController.text == null ||
            _socialNetworkController.text.isEmpty) {
          p.socialNetwork = null;
        } else {
          p.socialNetwork = _socialNetworkController.text;
        }

        if (_password != null && _password.isNotEmpty) {
          p.password = _password;
        } else {
          p.password = CurrentUser.profile.password;
        }
        dialogLoading.show();
        Api.confirmEdit(p)
            .then((value) => {
                  dialogLoading.stop(),
                  if (value.isSuccess())
                    {
                      CurrentUser.profile = p,
                      contactChanged = false,
                      _performSave(),
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
            .catchError((Object object) =>
                {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
      } else {
        _performSave();
      }
    }
  }

  void _performSave() {
    setState(() {
      _status = true;
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  Widget _getCameraIcon() {
    return new Icon(
      Icons.camera_alt,
      color: Colors.white,
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _buttonArea(void submit(), String text) => MaterialButton(
        onPressed: submit,
        child: Container(
          margin: const EdgeInsets.only(
            left: 11,
            right: 11,
            top: 22,
          ),
          padding: const EdgeInsets.all(7),
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
            color: Colors.blue[100],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      );

  Widget _buttonLogOutArea() => MaterialButton(
        onPressed: _performLogOut,
        child: Container(
          margin: const EdgeInsets.only(
            left: 50,
            right: 50,
            top: 40,
          ),
          padding: const EdgeInsets.all(7),
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
            color: Colors.blue[100],
          ),
          child: Text(
            'Log out',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      );

  void _performLogOut() {
    skillsCan = null;
    skillsWant = null;
    skills = null;
    skillsWant = null;
    skillsCan = null;
    outExc = null;
    inExc = null;
    curExc = null;
    completedExc = null;
    CurrentUser.profile = null;
    _socialNetworkController = TextEditingController();
    _aboutMeController = TextEditingController();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _performCan() {
    if (skillsCan == null) {
      dialogLoading.show();
      Api.getCanSkills(CurrentUser.profile)
          .then((value) => {
                dialogLoading.stop(),
                if (value.isSuccess())
                  {
                    skillsCan = value.getData(),
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => new Can())),
                  }
                else
                  {
                    skillsCan = List.empty(),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new Can()),
                    )
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    } else {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Can()));
    }
  }

  void _performWant() {
    if (skillsWant == null) {
      dialogLoading.show();
      Api.getWantSkills(CurrentUser.profile)
          .then((value) => {
                dialogLoading.stop(),
                if (value.isSuccess())
                  {
                    skillsWant = value.getData(),
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Want())),
                  }
                else
                  {
                    skillsWant = List.empty(),
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Want())),
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    } else {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new Want()));
    }
  }

  File _image;
  final picker = ImagePicker();

  Future _sendImage() {
    return Api.confirmPhoto(_image.readAsBytesSync())
        .then((value) => {
              if (value.isSuccess())
                {
                  dialogLoading.stop(),
                  setState(() {
                    imageProvider = MemoryImage(CurrentUser.profile.photoUri);
                  }),
                }
              else
                {dialogLoading.stop(), Error.errorSnackBar(globalKey)}
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) =>
            {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original
          ],
          maxWidth: 800);
      if (_image != null) {
        // setState(() {
        //   //
        // });
        var dialogLoading = DialogLoading(context: context);
        dialogLoading.show();
        await _sendImage()
            .then((value) => {
                  // Api.getUserByEmail(CurrentUser.profile.email)
                  //     .then((value) => {
                  //           if (value.isSuccess())
                  //             {
                  //               CurrentUser.profile = value.getData(),
                  //               setState(() {
                  //                 imageProvider =
                  //                     (value.getData().photoUri == null ||
                  //                             value.getData().photoUri.isEmpty)
                  //                         ? null
                  //                         : MemoryImage(value.getData().photoUri);
                  //               }),
                  //               setState(() {
                  //                 CurrentUser.profile = value.getData();
                  //                 imageProvider =
                  //                     MemoryImage(CurrentUser.profile.photoUri);
                  //               }),
                  //               dialogLoading.stop(),
                  //             }
                  //         })
                })
            .timeout(Duration(seconds: 90))
            .catchError((Object object) =>
                {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
      }
    }
  }

  void showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  "Выбрать из галерии",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text(
                  "Сделать фотографию",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  getImage(ImageSource.camera);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTap() {
    showPickOptionsDialog(context);
    //setState(() {});
  }
}
