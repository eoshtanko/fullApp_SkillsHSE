import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/exchanges/completedEx.dart';
import 'package:demoapp/view/mainApp/my_flutter_app_icons.dart';
import 'package:demoapp/view/mainApp/profile/constant.dart';
import 'package:demoapp/view/mainApp/profile/profilePage.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:demoapp/view/mainApp/search/search.dart';
import 'package:demoapp/view/mainApp/splashScreen.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'exchanges/currentEx.dart';

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SplashScreen(), //MyStatefulWidget(),
    );
  }
}

List<Skill> skillsG;

class MyStatefulWidget extends StatefulWidget {
  List<Skill> skillsN;

  // MyStatefulWidget({Key key}) : super(key: key);
  MyStatefulWidget({
    Key key,
    @required this.skillsN,
  }) : super(key: key);

  @override
  _MyStatefulWidgetState createState() =>
      _MyStatefulWidgetState(skillsN: skillsN);
}

int selectedIndex = 2;

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final globalKey = GlobalKey<ScaffoldState>();
  List<Skill> skillsN;

  _MyStatefulWidgetState({
    Key key,
    @required this.skillsN,
  });

  @override
  void initState() {
    super.initState();
    skillsG = skillsN;
  }

  static List<Widget> _widgetOptions = <Widget>[
    MySearchPage(
      mySkills: skillsG,
    ),
    MyCurrEx(),
    MyProfile(),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      dialogLoading.show();
      Api.getAllSkills()
          .then((value) => {
                if (value.isSuccess())
                  {
                    dialogLoading.stop(),
                    skills = value.getData(),
                    if (skills == null)
                      skills = List.empty()
                    else
                      skills.reversed.toList(),
                    setState(() {
                      selectedIndex = index;
                    })
                  }
                else
                  {dialogLoading.stop(), Error.errorSnackBar(globalKey)}
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    } else if (index == 1 /*&& curExc == null*/) {
      dialogLoading.show();
      Api.getCurEx()
          .then((value) => {
                if (value.isSuccess())
                  {
                    curExc = value.getData(),
                    if (curExc == null)
                      curExc = List.empty(),
                    dialogLoading.stop(),
                    setState(() {
                      selectedIndex = index;
                    })
                  }
                else
                  {dialogLoading.stop(), Error.errorSnackBar(globalKey)}
              })
          .timeout(Duration(seconds: 90))
          .catchError((Object object) =>
              {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    }
    // else if (index == 1 &&
    //     (curExc.length > 0 && curExc[0].users.length < 2)) {
    //   dialogLoading.show();
    //   Api.getCurExUsers(curExc)
    //       .then((value) => {
    //             if (value.isSuccess())
    //               {
    //                 dialogLoading.stop(),
    //                 curExc = value.getData(),
    //                 if (curExc == null)
    //                   {
    //                     curExc = List.empty(),
    //                   },
    //                 setState(() {
    //                   selectedIndex = index;
    //                 }),
    //               }
    //             else
    //               {dialogLoading.stop(), Error.errorSnackBar(globalKey)}
    //           })
    //       .timeout(Duration(seconds: 90))
    //       .catchError((Object object) =>
    //           {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
    // }
    else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  DialogLoading dialogLoading;

  @override
  Widget build(BuildContext context) {
    dialogLoading = new DialogLoading(context: context);
    return Scaffold(
      key: globalKey,
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              size: 30,
              color: Colors.blue,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.handshake, size: 30, color: Colors.blue),
            label: 'Exchanges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Colors.blue),
            label: 'Profile',
          ),
        ],

        currentIndex: selectedIndex,
        //       selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
