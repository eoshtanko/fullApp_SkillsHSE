import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:demoapp/view/mainApp/notMyProfile/notMyProfile.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'agreeToCompleteExchange.dart';
import 'commonWidgets.dart';
import 'completedEx.dart';
import 'inEx.dart';
import 'outEx.dart';

List<Exchange> curExc;

class MyCurrEx extends StatefulWidget {
  @override
  MyCurrExState createState() => MyCurrExState();
}

class MyCurrExState extends State<MyCurrEx> {
  BuildContext _context;
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    curExc = curExc;
    if (curExc == null) curExc = new List.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    Api.getCurEx().then((value) => {
          if (value.isSuccess()) {curExc = value.getData()}
        });
    dialogLoading = new DialogLoading(context: _context);
    return WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        key: globalKey,
        appBar: AppBar(
          leading: new Container(),
          title: Text('Текущие обмены', style: TextStyle(color: Colors.blue)),
          elevation: 1.0,
          brightness: Brightness.light,
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
          child: (curExc == null || curExc.isEmpty)
              ? Column(
                  children: <Widget>[
                    buildIm(),
                  ],
                )
              : new ListView(
                  //key: PageStorageKey(index),
                  children: [
                    for (Exchange exchange in curExc)
                      Item(
                        exchange: exchange,
                        withWhom: exchange.users[1],
                      )
                  ],
                ),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.lightBlue[300],
          foregroundColor: Colors.blue,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
              label: 'Завершенные',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: _performCompEx,
            ),
            SpeedDialChild(
              child: Icon(
                Icons.call_made_outlined,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
              label: 'Исходящие',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: _performOutEx,
            ),
            SpeedDialChild(
              child: Icon(
                Icons.call_received_outlined,
                color: Colors.blue,
              ),
              backgroundColor: Colors.white,
              label: 'Входящие',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: _performInEx,
            ),
          ],
        ),
      ),
    );
  }

  DialogLoading dialogLoading;

  Future<void> _performOutEx() async {
   // if (outExc == null) {
      dialogLoading.show();
      await Api.getOutEx()
          .then((value) => {
                if (value.isSuccess())
                  {
                    dialogLoading.stop(),
                    if (value.getData() != null)
                      outExc = value.getData().reversed.toList(),
                    if (outExc == null)
                      {
                        outExc = List.empty(),
                      },
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MyOutEx())),
                  }
                else
                  {
                    dialogLoading.stop(),
                    outExc = List.empty(),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MyOutEx()),
                    )
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    }
    // else if (outExc.length > 0 && outExc[0].users.length == 0) {
    //   dialogLoading.show();
    //   await Api.getOutExUsers(outExc)
    //       .then((value) => {
    //             if (value.isSuccess())
    //               {
    //                 dialogLoading.stop(),
    //                 if (value.getData() != null)
    //                   outExc = value.getData().reversed.toList(),
    //                 if (outExc == null)
    //                   {
    //                     outExc = List.empty(),
    //                   },
    //                 Navigator.push(
    //                     context,
    //                     new MaterialPageRoute(
    //                         builder: (context) => new MyOutEx())),
    //               }
    //             else
    //               {
    //                 dialogLoading.stop(),
    //                 outExc = List.empty(),
    //                 Navigator.push(
    //                   context,
    //                   new MaterialPageRoute(
    //                       builder: (context) => new MyOutEx()),
    //                 )
    //               }
    //           })
    //       .timeout(Duration(seconds: 90))
    //       .catchError((Object object) =>
    //           {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    // } else {
    //   Navigator.push(
    //       context, new MaterialPageRoute(builder: (context) => new MyOutEx()));
    // }
 // }

  // Future<void> _performCompEx() async {
  //   print(completedExc);
  //   if (completedExc != null) {
  //     dialogLoading.show();
  //     for (int i = 0; i < completedExc.length; i++) {
  //       Api.deleteExchange(completedExc[i].id, false).then((value) => {
  //             if (value.isSuccess())
  //               {print("Ура")}
  //             else
  //               {dialogLoading.stop(), print("Ой")}
  //           });
  //     }
  //     dialogLoading.stop();
  //   }
  // }

  Future<void> _performCompEx() async {
   // if (completedExc == null) {
      dialogLoading.show();
      Api.getCompEx()
          .then((value) => {
                if (value.isSuccess())
                  {
                    dialogLoading.stop(),
                    if (value.getData() != null)
                      completedExc = value.getData().reversed.toList(),
                    if (completedExc == null)
                      {
                        completedExc = List.empty(),
                      },
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MyCompEx())),
                  }
                else
                  {
                    dialogLoading.stop(),
                    completedExc = List.empty(),
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MyCompEx()),
                    )
                  }
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
   // }
    // else if (completedExc.length > 0 && completedExc[0].users.length < 2) {
    //   dialogLoading.show();
    //   await Api.getCompExUsers(completedExc)
    //       .then((value) => {
    //             if (value.isSuccess())
    //               {
    //                 dialogLoading.stop(),
    //                 if (value.getData() != null)
    //                   completedExc = value.getData().reversed.toList(),
    //                 if (completedExc == null)
    //                   {
    //                     completedExc = List.empty(),
    //                   },
    //                 Navigator.push(
    //                     context,
    //                     new MaterialPageRoute(
    //                         builder: (context) => new MyCompEx())),
    //               }
    //             else
    //               {
    //                 dialogLoading.stop(),
    //                 Error.errorSnackBar(globalKey),
    //               }
    //           })
    //       .timeout(Duration(seconds: 90))
    //       .catchError((Object object) =>
    //           {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    // } else {
    //   Navigator.push(
    //       context, new MaterialPageRoute(builder: (context) => new MyCompEx()));
    // }
  }

  Future<void> _performInEx() async {
    //if (inExc == null || (inExc.length > 0 && inExc[0].users.length == 0)) {
    dialogLoading.show();
    Api.getInEx()
        .then((value) => {
              if (value.isSuccess())
                {
                  dialogLoading.stop(),
                  if (value.getData() != null)
                    inExc = value.getData().reversed.toList(),
                  if (inExc == null)
                    {
                      inExc = List.empty(),
                    },
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MyInEx())),
                }
              else
                {
                  dialogLoading.stop(),
                  Error.errorSnackBar(globalKey),
                }
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) =>
            {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    //}
    // } else if (inExc.length > 0 && inExc[0].users.length == 0) {
    //   dialogLoading.show();
    //   await Api.getInExUsers(inExc)
    //       .then((value) => {
    //             if (value.isSuccess())
    //               {
    //                 dialogLoading.stop(),
    //                 if(value.getData() != null)
    //                 inExc = value.getData().reversed.toList(),
    //                 if (inExc == null)
    //                   {
    //                     inExc = List.empty(),
    //                   },
    //                 Navigator.push(
    //                     context,
    //                     new MaterialPageRoute(
    //                         builder: (context) => new MyInEx())),
    //               }
    //             else
    //               {
    //                 dialogLoading.stop(),
    //                 Error.errorSnackBar(globalKey),
    //               }
    //           })
    //       .timeout(Duration(seconds: 90))
    //       .catchError((Object object) =>
    //           {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    // } else {
    //   Navigator.push(
    //       context, new MaterialPageRoute(builder: (context) => new MyInEx()));
    // }
  }
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
  ItemState createState() =>
      new ItemState(exchange: exchange, withWhom: withWhom);
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
        padding: const EdgeInsets.only(bottom: 24),
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
            EWidgets.titleWidget("С кем:"),
            EWidgets.profile(goToProfile, withWhom),
            EWidgets.titleWidget("Что получаю:"),
            EWidgets.dataInfoAbout(exchange.skill1),
            EWidgets.titleWidget("Что даю:"),
            EWidgets.dataInfoAbout(exchange.skill2),
            (exchange.description != null && exchange.description.isNotEmpty)
                ? EWidgets.titleWidget("Сообщение:")
                : new Container(),
            (exchange.description != null && exchange.description.isNotEmpty)
                ? EWidgets.dataInfoAbout(exchange.description)
                : new Container(),
            _saveButtons(_context),
            // удалить // изменить
          ],
        ),
      );

  void complete() {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => AgreeToCompleteExchange(exchange: exchange)));
  }

  void goToProfile() {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) =>
                NotMyProfile(profile: withWhom, fromOut: false)));
  }

  Widget _saveButtons(context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 24.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Завершить"),
                textColor: Colors.white,
                color: Colors.blue[300],
                onPressed: complete,
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

Widget buildIm() => Flexible(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(90),
        child: Image.asset(
          'assets/images/33.png',
        ),
      ),
    );
