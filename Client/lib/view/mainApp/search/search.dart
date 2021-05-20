import 'dart:collection';

import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/search/searchP.dart';
import 'package:demoapp/view/mainApp/search/tune.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:demoapp/view/mainApp/search/viewSkill.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../notMyProfile/notMyProfile.dart';

DialogLoading dialogLoading;
List<Skill> skills;

class MySearchPage extends StatefulWidget {
  List<Skill> mySkills;

  MySearchPage({
    Key key,
    @required this.mySkills,
  });

  @override
  MySearchPageState createState() => MySearchPageState(mySkills: mySkills);
}

class MySearchPageState extends State<MySearchPage> {
  List<Skill> mySkills;

  MySearchPageState({
    Key key,
    @required this.mySkills,
  });

  void loadSkills() async {
    dialogLoading.show();
    Api.getAllSkills()
        .then((value) => {
              if (value.isSuccess())
                {
                  skills = value.getData(),
                  dialogLoading.stop(),
                  Navigator.pushNamed(context, 'profileP'),
                }
              else
                {
                  dialogLoading.stop(),
                  Error.errorSnackBar(globalKey)
                }
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) => {
              dialogLoading.stop(),
              Error.errorSnackBar(globalKey)
            });
  }

  BuildContext _context;
  int count = 0;

  UnmodifiableListView<Skill> get allSkills => UnmodifiableListView(skills);

  @override
  Widget build(BuildContext context) {
    Api.getAllSkills().then((value) => {
          if (value.isSuccess()) {skills = value.getData()}
        });
    _context = context;
    dialogLoading = DialogLoading(context: _context);
    ThemeData(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.white,
      textTheme: GoogleFonts.marmeladTextTheme(
        Theme.of(context).textTheme,
      ),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            loadSkills();
          },
          tooltip: 'add',
          child: Icon(
            Icons.refresh_outlined,
            color: Colors.blue,
          ),
        ),
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Найти навык', style: TextStyle(color: Colors.blue)),
          elevation: 1.0,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var result = await showSearch(
                  context: context,
                  delegate: SkillsSearch(allSkills),
                );
                if (result != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewSkill(skill: result)));
                }
              },
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.tune_rounded),
            onPressed: () async {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Tuune()));
            },
          ),
        ),
        // A nested navigator so we can push routes in the body from the drawer.
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            image: DecorationImage(
              image: AssetImage('assets/images/фон.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: (skills == null || skills.isEmpty)
              ? Column(
                  children: <Widget>[
                    buildIm(),
                  ],
                )
              : new ListView(
                  //key: PageStorageKey(index),
                  children: [
                    for (Skill skill in skills)
                      Item(
                        toggleCoinCallback: loadSkills,
                        name: skill.name,
                        des: skill.description,
                        id: skill.id,
                        category: categories[skill.category],
                        subCategory: categories[skill.category] == "Учеба"?
                        subcategoriesStudy[skill.subcategory]: subcategoriesNonStudy[skill.subcategory - 9],
                        skill: skill,
                      )
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildIm() => Flexible(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(90),
          child: Image.asset(
            'assets/images/3.png',
          ),
        ),
      );
}

class Item extends StatefulWidget {
  final _callback;
  final Function() notifyParent;
  String name;
  String des;
  String category;
  String subCategory;
  int id;
  Skill skill;

  Item({
    Key key,
    @required void toggleCoinCallback(),
    @required this.notifyParent,
    @required this.name,
    @required this.des,
    @required this.id,
    @required this.category,
    @required this.subCategory,
    @required this.skill,
  }) : _callback = toggleCoinCallback;

  @override
  ItemState createState() => ItemState(
      name: name,
      id: id,
      des: des,
      skill: skill,
      category: category,
      subCategory: subCategory);
}

class ItemState extends State<Item> {
  String name = "";
  String des = "";
  String category = "";
  String subCategory = "";
  int id;
  Skill skill;
  Profile pr;

  ItemState({
    Key key,
    @required this.name,
    @required this.des,
    @required this.category,
    @required this.subCategory,
    @required this.id,
    @required this.skill,
  }) : pr = Profile.fromJson(skill.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          _dataArea(context, des, id),
        ],
      ),
    );
  }

  Widget _dataArea(context, des, id) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 30),
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
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            _profile(),
            _titleWidget("Навык"),
            _dataShortInfoAbout(),
            (skill.description == null || skill.description.isEmpty)
                ? new Container()
                : _titleWidget("Подробное описание"),
            (skill.description == null || skill.description.isEmpty)
                ? new Container()
                : _dataInfoAbout(),
            _titleWidget("Категория"),
            _categoryInfoAbout(),
            _titleWidget("Подкатегория"),
            _subCategoryInfoAbout(),
            skill.userMail == CurrentUser.profile.email
                ? new Container()
                : _saveButtons(context),
          ],
        ),
      );

  Widget _prof() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: 50,
        height: 50,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.cover,
              image: (pr.photoUri == null || pr.photoUri.isEmpty)
                  ? null
                  : MemoryImage(
                      pr.photoUri), //MemoryImage(CurrentUser.profile.photoUri),
            )),
      ),
    );
  }

  void goToProfile() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotMyProfile(profile: pr, fromOut: false)));
  }

  Widget _profile() {
    return Padding(
        padding: EdgeInsets.only(left: 16.0, right: 25.0, top: 0.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new GestureDetector(
                  onTap: goToProfile,
                  child: _prof(),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.,
              children: <Widget>[
                new GestureDetector(
                  onTap: goToProfile,
                  child: new Container(
                    padding: EdgeInsets.only(left: 7.0, top: 20.0),
                    child: new Row(children: <Widget>[
                      new Text(
                        pr.name + " " + pr.surname + " ",
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      new Text(
                        (skill.status == 1 ? "может" : "хочет"),
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.blue,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _dataShortInfoAbout() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                            padding: EdgeInsets.only(bottom: 0),
                            child: new Text(
                              name,
                              //controller: _emailController,
                            ))),
                  ],
                ))),
      ),
    );
  }

  Widget _dataInfoAbout() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                          child: new Text(
                        des,
                      )),
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget _categoryInfoAbout() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                          padding: EdgeInsets.only(bottom: 0),
                          child: new Text(
                            category,
                          )),
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget _subCategoryInfoAbout() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                          padding: EdgeInsets.only(bottom: 0),
                          child: new Text(
                            subCategory,
                          )),
                    ),
                  ],
                ))),
      ),
    );
  }

//todo check whitespaces
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

  Widget _saveButtons(context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Обмен"),
                textColor: Colors.white,
                color: Colors.blue[300],
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewSkill(skill: skill))),
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
}
