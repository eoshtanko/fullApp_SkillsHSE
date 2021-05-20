import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/services.dart';
import 'package:demoapp/view/widgets/error.dart';

import 'addNewWant.dart';
import 'agreeToDelWant.dart';
import 'commonSkillsWidgets.dart';

List<Skill> skillsWant;

class Want extends StatefulWidget {

  @override
  WantState createState() => WantState();
}

class WantState extends State<Want> {
  final globalKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  DialogLoading dialogLoading;

  @override
  void initState() {
    super.initState();
    if(skillsWant == null) skillsWant = List.empty();
  }

  void loadSkills() {
    Api.getWantSkills(CurrentUser.profile).then((value) => {
      if (value.isSuccess())
      {skillsWant = value.getData(), setState(() {})}
      else{
        Error.errorSnackBar(
            globalKey), // todo timer
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: _context);
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text('Хочу', style: TextStyle(color: Colors.blue)),
          brightness: Brightness.light,
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, 'profileP');
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
            children: [
              for (Skill skill in skillsWant)
                Item(
                  skill: skill
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNewWant(
                    skill: null,
                    isNew: true,
                  )),
            );
          },
          tooltip: 'add',
          child: Icon(
            Icons.add,
            color: Colors.blue,
          ),
        ),
    );
  }

  Widget buildIm() => Flexible(
    child: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(90),
      child: Image.asset(
        'assets/images/33.png',
      ),
    ),
  );
}

class Item extends StatefulWidget {
  Skill skill;

  Item({
    Key key,
    @required this.skill,
  });

  @override
  ItemState createState() => ItemState(skill: this.skill);
}

class ItemState extends State<Item> {
  Skill skill;

  ItemState({
    Key key,
    @required this.skill,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          _dataArea(context, skill.id),
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
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        Widgets.subTitleWidget("Навык"),
        Widgets.dataWidget(skill.name),
        (skill.description == null || skill.description.isEmpty)? Container():
        Widgets.subTitleWidget("Подробное описание:"),
        (skill.description == null || skill.description.isEmpty)? Container():
        Widgets.dataWidget(skill.description),
        Widgets.subTitleWidget("Категория"),
        Widgets.dataWidget(categories[skill.category]),
        Widgets.subTitleWidget("Подкатегория"),
        Widgets.dataWidget(categories[skill.category] == "Учеба"?
        subcategoriesStudy[skill.subcategory]: subcategoriesNonStudy[skill.subcategory - 9]),
        _buttons(context, id),
      ],
    ),
  );

  Widget _buttons(context, id) {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getDelIcon(context, id),
            _getEditIcon(context),
          ],
        ));
  }

  Widget _getEditIcon(context) {
    return new Container(
      padding: EdgeInsets.only(right: 25.0),
      child: GestureDetector(
        child: new CircleAvatar(
          backgroundColor: Colors.blue[300],
          radius: 14.0,
          child: new Icon(
            Icons.edit,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        onTap: () async {
          // Ловим данные для обновления
         Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewWant(
                  skill: skill,
                  isNew: false,
                )),
          );
        },
      ),
    );
  }

  Widget _getDelIcon(context, id) {
    return new Container(
      padding: EdgeInsets.only(left: 25.0),
      child: GestureDetector(
        child: new CircleAvatar(
          backgroundColor: Colors.red[200],
          radius: 14.0,
          child: new Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgreeToDeleteWant(id: id)),
          );
        },
      ),
    );
  }
}
