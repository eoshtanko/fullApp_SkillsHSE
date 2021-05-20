import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/exchanges/completedEx.dart';
import 'package:demoapp/view/widgets/delete.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mainAppMap.dart';
import 'currentEx.dart';
import 'inEx.dart';

class AgreeToCompleteExchange extends StatelessWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  BuildContext _context;
  DialogLoading dialogLoading;
  Exchange exchange;

  AgreeToCompleteExchange({
    Key key,
    @required this.exchange,
  }) : super(key: key);

  void _argree() {
    dialogLoading.show();
    exchange.status = 2;
    Api.editExchange(exchange)
        .then((value) => {
      if (value.isSuccess())
        {
                  Api.getCurEx()
                      .then((value) => {
                            if (value.isSuccess())
                              {
                                dialogLoading.stop(),
                                curExc = value.getData(),
                                // Api.getCompEx()
                                //     .then((value) => {
                                //           if (value.isSuccess())
                                //             {
                                //               dialogLoading.stop(),
                                //               if(value.getData() != null)
                                //               completedExc = value.getData().reversed.toList(),
                                //               selectedIndex = 1,
                                //               Navigator.pushNamed(
                                //                   _context, 'profileP'),
                                //             }
                                //           else
                                //             {
                                //               dialogLoading.stop(),
                                //               Error.errorSnackBar(
                                //                   globalKey), // todo timer
                                //             }
                                //         })
                                //     .timeout(Duration(seconds: 90))
                                //     .catchError((Object object) => {
                                //           dialogLoading.stop(),
                                //           Error.errorSnackBar(globalKey)
                                //         }),
                              }
                            else
                              {
                                dialogLoading.stop(),
                                Error.errorSnackBar(globalKey), // todo timer
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
                Confirmation.mainArea(context, _argree, _disagree,
                    'Завершить обмен?', 'Да, завершить.', 'Нет, не завершать.'),
              ],
            )),
      ),
    );
  }
}
