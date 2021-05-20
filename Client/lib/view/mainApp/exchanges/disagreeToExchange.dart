import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/widgets/delete.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'currentEx.dart';
import 'inEx.dart';

class DisagreeToExchange extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  DialogLoading dialogLoading;
  Exchange exchange;

  DisagreeToExchange({
    Key key,
    @required this.exchange,
  }) : super(key: key);

  // todo
  void _argree() {
    dialogLoading.show();
    Api.deleteExchange(exchange.id, true)
        .then((value) => {
              if (value.isSuccess())
                {
                  Api.getInEx()
                      .then((value) => {
                            if (value.isSuccess())
                              {
                                dialogLoading.stop(),
                                if(value.getData() != null)
                                inExc = value.getData().reversed.toList(),
                                Navigator.push(
                                    _context,
                                    new MaterialPageRoute(
                                        builder: (context) => new MyInEx())),
                              }
                            else
                              {
                                dialogLoading.stop(),
                                Error.errorSnackBar(globalKey), // todo timer
                                Navigator.pop(_context),
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
                  Error.errorSnackBar(globalKey), // todo timer
                  Navigator.pop(_context),
                }
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) =>
            {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
  }

  void _disagree() {
    Navigator.pop(_context);
  }

  @override
  Widget build(BuildContext context) {
    dialogLoading = DialogLoading(context: context);
    _context = context;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: new Container(),
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
            child: ListView(
              children: <Widget>[
                Confirmation.mainArea(
                    context,
                    _argree,
                    _disagree,
                    'Отказать в обмене?',
                    'Да, отказать.',
                    'Нет, не отказывать.'),
              ],
            )),
      ),
    );
  }
}
