import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/api.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/services.dart';

import 'newExchange.dart';

bool noWant = true;

List<Skill> skillsWant;
Profile profile;

class Want extends StatefulWidget {
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<WantState>()
      : context.findAncestorStateOfType<WantState>();

  Want(List<Skill> data, Profile prof) {
    skillsWant = data;
    profile = prof;
  }

  @override
  WantState createState() => WantState();
}

class WantState extends State<Want> {

  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<WantState>()
      : context.findAncestorStateOfType<WantState>();

  @override
  void initState() {
    super.initState();
    if(skillsWant == null)
    skillsWant = List.empty();
  }

  void loadSkills() {
    Api.getWantSkills(profile).then((value) => {
      if (value.isSuccess()) {skillsWant = value.getData(), setState(() {})}
    });
  }

  BuildContext _context;
  int count = 0;
DialogLoading dialogLoading;

  @override
  Widget build(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: _context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Хочет', style: TextStyle(color: Colors.blue)),
          brightness: Brightness.light,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
          child: (skillsWant == null || skillsWant.isEmpty)
              ? Column(
            children: <Widget>[
              buildIm(),
            ],
          )
              : new ListView(
            //key: PageStorageKey(index),
            children: [
              for (Skill skill in skillsWant)
                Item(
                  name: skill.getName,
                  skill: skill,
                  des: skill.getDescription,
                  id: skill.getId,
                  category: categories[skill.getCategory],
                  subCategory: categories[skill.category] == "Учеба"?
                  subcategoriesStudy[skill.subcategory]: subcategoriesNonStudy[skill.subcategory - 9],
                )
            ],
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
  Skill skill;
  String name;
  String des;
  String category;
  String subCategory;
  int id;

  Item({
    Key key,
    @required this.name,
    @required this.des,
    @required this.skill,
    @required this.id,
    @required this.category,
    @required this.subCategory,
  });

  @override
  ItemState createState() => ItemState(
      skill: skill,
      name: this.name,
      id: id,
      des: des,
      category: category,
      subCategory: subCategory);
}

class ItemState extends State<Item> {
  Skill skill;
  String name;
  String des;
  String category;
  String subCategory;
  int id;

  ItemState({
    Key key,
    @required this.name,
    @required this.des,
    @required this.category,
    @required this.skill,
    @required this.subCategory,
    @required this.id,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          _dataArea(context, id),
        ],
      ),
    );
  }

  Widget _dataArea(context, id) => Container(
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
      // BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        _titleWidget("Навык"),
        _dataShortInfoAbout(),
        (des != null && des.isNotEmpty)?
        _titleWidget("Подробное описание:"):
        new Container(),
        (des != null && des.isNotEmpty)?
        _dataInfoAbout():
        new Container(),
        _titleWidget("Категория"),
        _categoryInfoAbout(),
        _titleWidget("Подкатегория"),
        _subCategoryInfoAbout(),
        _saveButtons(context),
      ],
    ),
  );

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
                            builder: (context) => ViewSkillSec(skill: skill, user: profile))),
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
                          padding: EdgeInsets.only(bottom: 0),
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
}
