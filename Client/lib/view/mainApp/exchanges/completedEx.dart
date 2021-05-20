import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mainAppMap.dart';
import 'agreeToDelExchange.dart';
import 'changeExchange.dart';
import 'commonWidgets.dart';

List<Exchange> completedExc;

class MyCompEx extends StatefulWidget {
  @override
  MyCompExState createState() => MyCompExState();
}

class MyCompExState extends State<MyCompEx> {
  BuildContext _context;
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _context = context;
    Api.getCompEx().then((value) => {
      if (value.isSuccess()) {
        if(value.getData() != null)
        completedExc = value.getData().reversed.toList()
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Завершенные обмены', style: TextStyle(color: Colors.blue)),
          brightness: Brightness.light,
          leading: BackButton(
            onPressed: () {
              selectedIndex = 1;
              Navigator.pushNamed(context, 'profileP');
            },
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
          child: (completedExc == null || completedExc.isEmpty)
              ? Column(
            children: <Widget>[
              buildIm(),
            ],
          )
              : new ListView(
            children: [
              for (Exchange exchange in completedExc)
                Item(
                  exchange: exchange,
                  withWhom:
                  exchange.users[1],
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
        'assets/images/33.png',
      ),
    ),
  );
}

class Item extends StatefulWidget {
  Exchange exchange;
  Profile withWhom;

  Item({
    Key key,
    @required this.exchange,
    @required this.withWhom,
  });

  @override
  ItemState createState() => new ItemState(exchange: exchange, withWhom: withWhom);
}

class ItemState extends State<Item> {
  BuildContext _context;
  Exchange exchange;
  Profile withWhom;

  ItemState({
    Key key,
    @required this.exchange,
    @required this.withWhom,
  }) : super();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Column(
        children: <Widget>[
          _dataArea(context),
        ],
      ),
    );
  }
  Widget _dataArea(context) => Container(
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
      color: Colors.grey[300],
    ),
    child: Column(
      children: <Widget>[
        // c кем
        EWidgets.titleWidget("С кем:"),
        EWidgets.profile(goToProfile, withWhom),
        EWidgets.titleWidget("Что получил:"),
        EWidgets.dataInfoAbout(exchange.skill2),
        EWidgets.titleWidget("Что дал:"),
        EWidgets.dataInfoAbout(exchange.skill1),
        (exchange.description != null && exchange.description.isNotEmpty)
            ? EWidgets.titleWidget("Сообщение:")
            : new Container(),
        (exchange.description != null && exchange.description.isNotEmpty)
            ? EWidgets.dataInfoAbout(exchange.description)
            : new Container(),
        // удалить // изменить
      ],
    ),
  );


  void goToProfile() {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => NotMyProfile(profile: withWhom, fromOut: false,)));
  }
}
