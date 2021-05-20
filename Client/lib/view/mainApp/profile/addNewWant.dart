import 'dart:ui';

import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/validators.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:demoapp/view/mainApp/profile/commonSkillsWidgets.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'want.dart';

Skill skillToChange;
BuildContext _context;
final _nameController = TextEditingController();
final _desController = TextEditingController();
final globalKey = GlobalKey<ScaffoldState>();
String dropdownValueMainTune;
String dropdownValueSubStudy;
String dropdownValueSubNonStudy;
bool mainTuneChanged1 = true;
bool mainTuneChanged = false;
bool subTuneChanged = true;
bool mainTuneStudy = true;

class AddNewWant extends StatefulWidget {
  final Skill skill;
  final bool isNew;

  const AddNewWant({
    Key key,
    @required this.skill,
    @required this.isNew,
  }) : super(key: key);

  @override
  AddNewWantState createState() => AddNewWantState(
        skill: skill,
        isNew: isNew,
      );
}

class AddNewWantState extends State<AddNewWant> {
  DialogLoading dialogLoading;
  DialogLoading isValidNameOrSurnamedialogLoading;
  var formKeyName = new GlobalKey<FormState>();
  var formKeyInfo = new GlobalKey<FormState>();
  final Skill skill;
  final bool isNew;
  bool isFirstUpp = true;

  @override
  void initState() {
    formKeyName = new GlobalKey<FormState>();
    formKeyInfo = new GlobalKey<FormState>();
    skillToChange = skill;
    super.initState();
  }

  AddNewWantState({
    Key key,
    @required this.skill,
    @required this.isNew,
  });

  void _performWant() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new Want()));
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: _context);
    var test = 'Back';
    if (skill == null && isFirstUpp) {
      isFirstUpp = false;
      _nameController.text = "";
      _desController.text = "";
      dropdownValueMainTune = null;
      dropdownValueSubStudy = null;
      dropdownValueSubNonStudy = null;
      mainTuneChanged = false;
      mainTuneStudy = true;
      mainTuneChanged1 = true;
    } else if (isFirstUpp) {
      isFirstUpp = false;
      mainTuneChanged = true;
      mainTuneChanged1 = true;
      mainTuneStudy = categories[skill.category] == "Учеба" ? true : false;
      _nameController.text = skill.name;
      _desController.text = skill.description;
      dropdownValueMainTune = categories[skill.category];
      if (mainTuneStudy) {
        dropdownValueSubStudy = subcategoriesStudy[skill.subcategory];
        dropdownValueSubNonStudy = null;
      } else {
        dropdownValueSubStudy = null;
        dropdownValueSubNonStudy = subcategoriesNonStudy[skill.subcategory - 9];
      }
    }
    return Scaffold(
        key: globalKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
            onPressed: _performWant,
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
          child: new ListView(
            children: [
              Widgets.mainTitleWidget('Я хочу'),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 30),
                padding: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
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
                    Widgets.subTitleWidget("Навык"),
                    _nameWidget(),
                    Widgets.subTitleWidget("Подробное описание:"),
                    _infoWidget(),
                    Widgets.subTitleWidget("Категория"),
                    Widgets.dropDownMenuWidget(
                        Container(
                            child: DropdownButton<String>(
                          isExpanded: true,
                          value: dropdownValueMainTune,
                          hint: Text("Не выбрана"),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          underline: Container(),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueMainTune = newValue;
                              mainTuneChanged = true;
                              mainTuneChanged1 = true;
                              if (newValue == 'Учеба') {
                                mainTuneStudy = true;
                              } else {
                                mainTuneStudy = false;
                              }
                            });
                          },
                          items: categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                        mainTuneChanged1),
                    mainTuneChanged
                        ? Widgets.subTitleWidget("Подкатегория")
                        : new Container(),
                    mainTuneChanged
                        ? Widgets.dropDownMenuWidget(
                            Container(
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: mainTuneStudy
                                        ? dropdownValueSubStudy
                                        : dropdownValueSubNonStudy,
                                    icon: Icon(Icons.arrow_drop_down),
                                    hint: Text("Не выбрана"),
                                    iconSize: 30,
                                    elevation: 16,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                    underline: Container(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        subTuneChanged = true;
                                        if (mainTuneStudy) {
                                          dropdownValueSubStudy = newValue;
                                          dropdownValueSubNonStudy = null;
                                        } else {
                                          dropdownValueSubStudy = null;
                                          dropdownValueSubNonStudy = newValue;
                                        }
                                      });
                                    },
                                    items: mainTuneStudy
                                        ? subcategoriesStudy
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList()
                                        : subcategoriesNonStudy
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList())),
                            subTuneChanged)
                        : new Container(),
                    Widgets.saveButtonWidget(_submit, context, isNew, skill),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _nameWidget() {
    return Container(
      child: new Form(
        key: formKeyName,
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                          child: Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:
                                        "Наименование навыка (3<=знаков<=50)"),
                                maxLength: 50,
                                maxLengthEnforced: true,
                                maxLines: 2,
                                controller: _nameController,
                                validator: (val) =>
                                    !Validator.isValidNameOrSurname(val)
                                        ? 'Not a valid name.'
                                        : null,
                                //controller: _emailController,
                              ))),
                    ],
                  ))),
        ),
      ),
    );
  }

  Widget _infoWidget() {
    return Container(
      child: new Form(
        key: formKeyInfo,
        child: Container(
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          padding: EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Flexible(
                          child: Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: new TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    hintText:
                                        "Опишите подробнее (не более 300 знаков)"),
                                maxLength: 300,
                                // controller: _aboutController,
                                maxLengthEnforced: true,
                                maxLines: 8,
                                controller: _desController,
                              ))),
                    ],
                  ))),
        ),
      ),
    );
  }

  void _submit(context, isNew, skill) async {
    final formName = formKeyName.currentState;
    final formInfo = formKeyInfo.currentState;
    if (formName.validate()) {
      formName.save();
      formInfo.save();
      if (dropdownValueMainTune != null) {
        if (dropdownValueSubStudy != null || dropdownValueSubNonStudy != null) {
          if (mainTuneChanged && subTuneChanged) {
            String subCat =
            mainTuneStudy ? dropdownValueSubStudy : dropdownValueSubNonStudy;

            if (isNew) {
              for(Skill skill in skillsWant){
                if(skill.name.trim().toLowerCase() == _nameController.text.trim().toLowerCase()
                    && skill.description.trim().toLowerCase()  == _desController.text.trim().toLowerCase()  &&
                    skill.category == categories.indexOf(dropdownValueMainTune)
                    && skill.subcategory == (mainTuneStudy? subcategoriesStudy.indexOf(subCat) : subcategoriesNonStudy.indexOf(subCat) + 9)){

                  globalKey.currentState.showSnackBar(SnackBar(
                      backgroundColor: Colors.white,
                      duration: Duration(seconds: 3),
                      content: Text(
                        "\n\n Такой навык уже существует.\n\n\n\n\n",
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      )));

                  return;
                }
              }

              Skill skill = new Skill(
                  0,
                  2,
                  _nameController.text,
                  _desController.text,
                  categories.indexOf(dropdownValueMainTune),
                  mainTuneStudy? subcategoriesStudy.indexOf(subCat) : subcategoriesNonStudy.indexOf(subCat) + 9,
                  CurrentUser.profile.email,
                  CurrentUser.profile.toJson());
              hideKeyboard();
              FocusScope.of(_context).unfocus();
              if (skill != null) {
                dialogLoading.show();
                Api.addSkill(skill)
                    .then((value) => {
                          if (value.isSuccess())
                            {
                              Api.renewUser()
                                  .then((value) => {
                                        if (value.isSuccess())
                                          {
                                            dialogLoading.stop(),
                                            skillsWant = CurrentUser
                                                .profile.skills
                                                .where((element) =>
                                                    element.status == 2)
                                                .toList(),
                                            Navigator.push(
                                                _context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new Want())),
                                          }
                                        else
                                          {
                                            dialogLoading.stop(),
                                            Navigator.pop(_context),
                                            Error.errorSnackBar(globalKey),
                                          }
                                      })
                                  .timeout(Duration(seconds: 90))
                                  .catchError((Object object) => {
                                        dialogLoading.stop(),
                                        Error.errorSnackBar(globalKey)
                                      }),
                            }
                          else
                            {
                              dialogLoading.stop(),
                              Error.errorSnackBar(globalKey)
                            }
                        })
                    .timeout(Duration(seconds: 90))
                    .catchError((Object object) =>
                        {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
              }
            } else {
              if (skillToChange.name != _nameController.text ||
                  skillToChange.description != _desController.text ||
                  skillToChange.category !=
                      categories.indexOf(dropdownValueMainTune) ||
                  skillToChange.subcategory != (mainTuneStudy? subcategoriesStudy.indexOf(subCat) : subcategoriesNonStudy.indexOf(subCat) + 9)) {

                for(Skill skill in skillsWant){
                  if(skill.name.trim().toLowerCase() == _nameController.text.trim().toLowerCase()
                      && skill.description.trim().toLowerCase()  == _desController.text.trim().toLowerCase()  &&
                      skill.category == categories.indexOf(dropdownValueMainTune)
                      && skill.subcategory == (mainTuneStudy? subcategoriesStudy.indexOf(subCat) : subcategoriesNonStudy.indexOf(subCat) + 9)){
                    if(skill.id != skillToChange.id) {
                      globalKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(seconds: 3),
                          content: Text(
                            "\n\n Такой навык уже существует.\n\n\n\n\n",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          )));

                      return;
                    }
                  }
                }

                Skill newSkill = new Skill(
                    skill.id,
                    2,
                    _nameController.text,
                    _desController.text,
                    categories.indexOf(dropdownValueMainTune),
                    mainTuneStudy? subcategoriesStudy.indexOf(subCat) : subcategoriesNonStudy.indexOf(subCat) + 9,
                    CurrentUser.profile.email,
                    CurrentUser.profile.toJson());
                hideKeyboard();
                FocusScope.of(_context).unfocus();
                if (newSkill != null) {
                  dialogLoading.show();
                  Api.editSkill(newSkill)
                      .then((value) => {
                            if (value.isSuccess())
                              {
                                Api.renewUser()
                                    .then((value) => {
                                          if (value.isSuccess())
                                            {
                                              dialogLoading.stop(),
                                              skillsWant = CurrentUser
                                                  .profile.skills
                                                  .where((element) =>
                                                      element.status == 2)
                                                  .toList(),
                                              Navigator.push(
                                                  _context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new Want())),
                                            }
                                          else
                                            {
                                              dialogLoading.stop(),
                                              Error.errorSnackBar(globalKey),
                                            }
                                        })
                                    .timeout(Duration(seconds: 90))
                                    .catchError((Object object) => {
                                          dialogLoading.stop(),
                                          Error.errorSnackBar(globalKey)
                                        }),
                              }
                            else
                              {
                                dialogLoading.stop(),
                                Error.errorSnackBar(globalKey),
                              }
                          })
                      .timeout(Duration(seconds: 90))
                      .catchError((Object object) => {
                            dialogLoading.stop(),
                            Error.errorSnackBar(globalKey)
                          });
                }
              } else {
                Navigator.pop(_context);
              }
            }
          }
        } else {
          setState(() {
            subTuneChanged = false;
          });
        }
      } else {
        setState(() {
          mainTuneChanged1 = false;
        });
      }
    }
  }
}
