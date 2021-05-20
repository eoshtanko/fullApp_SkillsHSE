import 'package:demoapp/data/generalInfo.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/logic/api.dart';
import 'package:demoapp/view/mainApp/notMyProfile/wantSkills.dart';
import 'package:demoapp/view/widgets/dialog.dart';
import 'package:demoapp/view/widgets/error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'canSkills.dart';

Profile currentProfile;
final _emailController = TextEditingController();
final _nameController = TextEditingController();
final _surnameController = TextEditingController();
final _ageController = TextEditingController();
final _sexController = TextEditingController();
final _socialNetworkController = TextEditingController();
final _aboutMeController = TextEditingController();
final _eduProgramController = TextEditingController();
final _dormController = TextEditingController();
final _stageOfEduController = TextEditingController();
final _buildingController = TextEditingController();

bool fromOutG;

class NotMyProfile extends StatelessWidget {
  Profile profile;
  bool fromOut;

  NotMyProfile({
    Key key,
    @required this.profile,
    @required this.fromOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    fromOutG = fromOut;
    _emailController.text = profile.email;
    _nameController.text = profile.name;
    _surnameController.text = profile.surname;
    _ageController.text = profile.birthday.toString();
    _sexController.text = sexes[profile.gender];
    _buildingController.text = buildings[profile.campus];
    _eduProgramController.text = eduPrograms[profile.eduProgram];
    _dormController.text = dormitories[profile.dormitory];
    _stageOfEduController.text = stagesOfEdu[profile.stageOfEdu];
    _socialNetworkController.text = profile.socialNetwork;
    _aboutMeController.text = profile.aboutMe;
    currentProfile = profile;
    return Scaffold(
      appBar: null,
      body: new ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  Image im;

  @override
  void initState() {
    super.initState();
  }

  void _perform() {
    if(!fromOutG) {
      Navigator.pop(_context);
    } else{
      Navigator.pushNamed(context, 'outExc');
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    dialogLoading = DialogLoading(context: this._context);
    return Scaffold(
          key: globalKey,
          appBar: AppBar(
            leading: BackButton(
              onPressed: _perform,
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
            title: Text('Профиль', style: TextStyle(color: Colors.blue)),
            elevation: 1.0,
          ),
          body: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 180.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            //todo
                            child: new Stack(
                                fit: StackFit.loose,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      (currentProfile.photoUri == null ||
                                              currentProfile.photoUri.isEmpty)
                                          ? new Container(
                                              width: 150.0,
                                              height: 150.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    image: new ExactAssetImage(
                                                        'assets/images/88.png'),
                                                    fit: BoxFit.cover,
                                                  )),
                                            )
                                          : new Container(
                                              width: 150.0,
                                              height: 150.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: (currentProfile
                                                                    .photoUri ==
                                                                null ||
                                                            currentProfile
                                                                .photoUri
                                                                .isEmpty)
                                                        ? null
                                                        : MemoryImage(currentProfile
                                                            .photoUri), //MemoryImage(CurrentUser.profile.photoUri),
                                                  )),
                                              //child: Imm(),
                                            )
                                    ],
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 0.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Данные',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            _buttonArea(_performCan, 'Может'),
                            _buttonArea(_performWant, 'Хочет'),
                            _titleWidget('Имя'),
                            _textArea(_nameController),
                            _titleWidget('Фамилия'),
                            _textArea(_surnameController),
                            _titleWidget('Email'),
                            _textArea(_emailController),
                            (currentProfile.socialNetwork == null ||
                                    currentProfile.socialNetwork.isEmpty)
                                ? new Container()
                                : _titleWidget('Социальная сеть'),
                            (currentProfile.socialNetwork == null ||
                                    currentProfile.socialNetwork.isEmpty)
                                ? new Container()
                                : _textArea(_socialNetworkController),
                            (currentProfile.aboutMe == null ||
                                    currentProfile.aboutMe.isEmpty)
                                ? new Container()
                                : _titleWidget('О себе'),
                            (currentProfile.aboutMe == null ||
                                    currentProfile.aboutMe.isEmpty)
                                ? new Container()
                                : _dataInfoAboutMe(),
                            _titleWidget('Образовательная программа'),
                            _textArea(_eduProgramController),
                            _titleWidget('Общежитие'),
                            _textArea(_dormController),
                            _titleWidget('Ступень обучения'),
                            _textArea(_stageOfEduController),
                            _titleWidget('Расположение корпуса'),
                            _textArea(_buildingController),
                            _titleWidget('Пол'),
                            _textArea(_sexController),
                            _titleWidget('Дата рождения'),
                            _showAgeArea(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
    );
  }

  DateTime _chosenDateTime = currentProfile.birthday;

  Widget _showAgeArea() => Container(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 4.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Flexible(
            child: Container(
                margin: const EdgeInsets.only(top: 14, left: 0, right: 0),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Text(
                        _chosenDateTime != null
                            ? ("День: " +
                                    _chosenDateTime.day.toString() +
                                    " " +
                                    " Месяц: " +
                                    _chosenDateTime.month.toString() +
                                    " " +
                                    " Год: " +
                                    _chosenDateTime.year.toString()) +
                                ""
                            : 'Выбрать дату',
                        style: TextStyle(
                            //fontSize: 24,
                            fontSize: 16.0,
                            //fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ));

  Widget _textArea(TextEditingController controller) => Container(
        child: new Form(
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Flexible(
                  child: new TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    controller: controller,
                    enabled: false,
                  ),
                ),
                //enterButtonArea(),
              ],
            ),
          ),
        ),
      );

  Widget _dataInfoAboutMe() {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 25, right: 25),
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Flexible(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: new Text(
                          _aboutMeController.text,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ))));
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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  DialogLoading dialogLoading;
  BuildContext _context;
  final globalKey = GlobalKey<ScaffoldState>();

  Widget _buttonArea(void submit(), String text) => MaterialButton(
        onPressed: submit,
        child: Container(
          margin: const EdgeInsets.only(
            left: 11,
            right: 11,
            top: 22,
          ),
          padding: const EdgeInsets.all(7),
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[100],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      );

  void _performCan() {
    dialogLoading.show();
    Api.getCanSkills(currentProfile)
        .then((value) => {
              dialogLoading.stop(),
              if (value.isSuccess())
                {
                  skillsCan = value.getData(),
                  if (skillsCan == null)
                    {
                      skillsCan = List.empty(),
                    },
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new Can(skillsCan, currentProfile))),
                }
              else
                {
                  Error.errorSnackBar(globalKey),
                }
            })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) =>
            {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
  }

  void _performWant() {
    dialogLoading.show();
    Api.getWantSkills(currentProfile)
        .then((value) => {
      dialogLoading.stop(),
      if (value.isSuccess())
        {
          skillsWant = value.getData(),
          if (skillsWant == null)
            {
              skillsWant = List.empty(),
            },
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new Want(skillsWant, currentProfile))),
        }
      else
        {
          Error.errorSnackBar(globalKey),
        }
    })
        .timeout(Duration(seconds: 90))
        .catchError((Object object) =>
    {dialogLoading.stop(), Error.errorSnackBar(globalKey)});
  }
}
