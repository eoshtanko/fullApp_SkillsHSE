import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/widgets/delete.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'currentEx.dart';
import 'outEx.dart';

class AgreeToDelExchange extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  DialogLoading dialogLoading;
  int id;

  AgreeToDelExchange({
    Key key,
    @required this.id,
  }) : super(key: key);

  void _argreeToDel() {
    dialogLoading.show();
    Api.deleteExchange(id, false)
        .then((value) => {
              if (value.isSuccess())
                {
                  Api.getOutEx()
                      .then((value) => {
                            if (value.isSuccess())
                              {
                                dialogLoading.stop(),
                                if(value.getData() != null)
                                outExc = value.getData().reversed.toList(),
                                Navigator.push(
                                    _context,
                                    new MaterialPageRoute(
                                        builder: (context) => new MyOutEx())),
                              }
                            else
                              {
                                Error.errorSnackBar(globalKey),
                                dialogLoading.stop(), // todo timer
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
                  Error.errorSnackBar(globalKey),
                  dialogLoading.stop(),
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
                Confirmation.mainArea(context, _disagree, _argreeToDel,
                    'Точно удалить?', 'Нет, не удалять.', 'Да, удалить.'),
              ],
            )),
      ),
    );
  }
}
