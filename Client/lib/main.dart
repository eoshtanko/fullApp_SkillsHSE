import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'view/firstPage.dart';
import 'view/mainApp/exchanges/outEx.dart';
import 'view/mainApp/mainAppMap.dart';
import 'view/mainApp/search/search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return
       MaterialApp(
        routes: <String, WidgetBuilder>{
          'profileP' : (BuildContext context) =>  new MyStatefulWidget(skillsN: skills,),
          'outExc' : (BuildContext context) => new MyOutEx(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          backgroundColor: Colors.white,
          textTheme: GoogleFonts.marmeladTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: EnterPage(),
    );
  }
}