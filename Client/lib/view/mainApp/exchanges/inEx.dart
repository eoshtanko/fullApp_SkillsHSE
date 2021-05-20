import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/exchanges/agreeToExchange.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mainAppMap.dart';
import 'agreeToDelExchange.dart';
import 'changeExchange.dart';
import 'commonWidgets.dart';
import 'disagreeToExchange.dart';

List<Exchange> inExc;
class MyInEx extends StatefulWidget {
  @override
  MyInExState createState() => MyInExState();
}

class MyInExState extends State<MyInEx> {
  BuildContext _context;
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    inExc = inExc;
    if(inExc == null)
      inExc = List.empty();
    super.initState();
  }

  void goBack(context){

  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    Api.getInEx().then((value) => {
      if (value.isSuccess()) {
        if(value.getData() != null)
        inExc = value.getData().reversed.toList()}
    });
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text('Входящие обмены', style: TextStyle(color: Colors.blue)),
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
          child: (inExc == null || inExc.isEmpty)
              ? Column(
            children: <Widget>[
              buildIm(),
            ],
          )
              : new ListView(
            children: [
              for (Exchange exchange in inExc)
                Item(
                  exchange: exchange,
                  withWhom:
                  exchange.users[0].email == exchange.receiverMail
                      ? exchange.users[1]
                      : exchange.users[0],
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
      color: Colors.white,
    ),
    child: Column(
      children: <Widget>[
        // c кем
        EWidgets.titleWidget("Кто предложил:"),
        EWidgets.profile(goToProfile, withWhom),
        EWidgets.titleWidget("Что предлагает:"),
        EWidgets.dataInfoAbout(exchange.skill1),
        EWidgets.titleWidget("Что взамен:"),
        EWidgets.dataInfoAbout(exchange.skill2),
        (exchange.description != null && exchange.description.isNotEmpty)
            ? EWidgets.titleWidget("Сообщение:")
            : new Container(),
        (exchange.description != null && exchange.description.isNotEmpty)
            ? EWidgets.dataInfoAbout(exchange.description)
            : new Container(),
        _buttons(context, exchange.id),
        // удалить // изменить
      ],
    ),
  );

  void goToProfile() {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => NotMyProfile(profile: withWhom, fromOut: false)));
  }

  Widget _buttons(context, id) {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _disagree(context, id),
            _agree(context),
          ],
        ));
  }

  Widget _agree(context) {
    return new Container(
      padding: EdgeInsets.only(right: 25.0),
      child: GestureDetector(
        child: new CircleAvatar(
          backgroundColor: Colors.green[300],
          radius: 14.0,
          child: new Icon(
            Icons.check,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgreeToExchange(exchange: exchange)),
          );
        },
      ),
    );
  }

  Widget _disagree(context, id) {
    return new Container(
      padding: EdgeInsets.only(left: 25.0),
      child: GestureDetector(
        child: new CircleAvatar(
          backgroundColor: Colors.red[200],
          radius: 14.0,
          child: new Icon(
            Icons.clear,
            color: Colors.white,
            size: 16.0,
          ),
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DisagreeToExchange(exchange: exchange)),
          );
        },
      ),
    );
  }
}
