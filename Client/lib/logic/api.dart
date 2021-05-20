import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:demoapp/data/exchange.dart';
import 'package:demoapp/data/profile.dart';
import 'package:demoapp/view/mainApp/exchanges/completedEx.dart';
import 'package:demoapp/view/mainApp/exchanges/currentEx.dart';
import 'package:demoapp/view/mainApp/exchanges/inEx.dart';
import 'package:demoapp/view/mainApp/exchanges/outEx.dart';
import 'package:demoapp/view/mainApp/profile/want.dart';
import 'package:demoapp/view/mainApp/profile/can.dart';
import 'package:demoapp/view/mainApp/search/search.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:demoapp/data/skill.dart';
import 'package:demoapp/logic/currentUser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'eventWrapper.dart';

class Api {
  static const String _LocalIp = "https://sharingskillshsebackend.azurewebsites.net";

  static Random random = new Random();

  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<EventWrapper<bool>> recovery(String email) async {
    final response =
        await http.get('$_LocalIp/api/Users/$email/password', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.statusCode == 400) {
      return EventWrapper(
          response.statusCode, null, "Данный адрес не зарегистрирован!");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> del(String email) async {

     var response = await http.delete('$_LocalIp/api/Users/$email', headers: headers);


    print("Код: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }


  static Future<EventWrapper<bool>> sendCode(String email) async {
    var responseProf =
        await http.get('$_LocalIp/api/Users/$email', headers: headers);

    if (responseProf.statusCode == 200) {
      var profile = Profile.fromJson(jsonDecode(responseProf.body));
      if (profile.password != null &&
          profile.password.isNotEmpty &&
          profile.name != null &&
          profile.surname != null &&
          profile.eduProgram != null &&
          profile.stageOfEdu != null &&
          profile.dormitory != null &&
          profile.birthday != null &&
          profile.gender != null &&
          profile.campus != null) {
        return EventWrapper(
            400, null, "Данный пользователь уже зарегистрирован!");
      }
      await http.delete('$_LocalIp/api/Users/$email', headers: headers);
    }

    CurrentUser.profile = new Profile();
    CurrentUser.profile.email = email;
    CurrentUser.profile.confirmationCodeServer = 0;
    CurrentUser.profile.confirmationCodeUser = 0;
    CurrentUser.profile.birthday = new DateTime(0001, 01, 01, 00, 00, 00);
    CurrentUser.profile.gender = 0;
    CurrentUser.profile.stageOfEdu = 0;
    CurrentUser.profile.eduProgram = 0;
    CurrentUser.profile.campus = 0;
    CurrentUser.profile.dormitory = 0;
    CurrentUser.profile.transactions = new List.empty();
    CurrentUser.profile.skills = new List.empty();
    var jsonEnc = json.encode(CurrentUser.profile.toJson());

    Api.getAllSkills().then((value) => {
      if (value.isSuccess()) {skills = value.getData()}
    });

    print(jsonEnc);

    final response = await http.post('$_LocalIp/api/Users/',
        body: jsonEnc, headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmCode(int code) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.confirmationCodeUser = code;

    print(profile.confirmationCodeServer);

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }


  static Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  static Future<EventWrapper<bool>> confirmPassword(String pass) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));
    profile.password = pass;

    final byteData = await rootBundle.load('assets/images/88.png');
    profile.photoUri = (byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmPhoto(List<int> photo) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.photoUri = photo;

    CurrentUser.profile = profile;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmNameAndSurname(
      String name, String surname) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.name = name;
    profile.surname = surname;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204 || responseFinal.statusCode == 200) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmDateOfBirthday(
      DateTime birthday) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.birthday = birthday;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmSex(int sex) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.gender = sex;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmStageOfEdu(int stage) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.stageOfEdu = stage;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      CurrentUser.profile.stageOfEdu = stage;
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmEduProgram(int program) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.eduProgram = program;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      CurrentUser.profile.eduProgram = program;
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmBuilding(int build) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.campus = build;

    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      CurrentUser.profile.campus = build;
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmDormitory(int dorm) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    profile.dormitory = dorm;

    CurrentUser.profile = profile;
    var jsonEnc = json.encode(profile.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      CurrentUser.profile.dormitory = dorm;
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<Profile>> getUserByEmail(String email) async {
    var response =
        await http.get('$_LocalIp/api/Users/$email', headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, profile, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> renewUser() async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profile = Profile.fromJson(jsonDecode(response.body));

    CurrentUser.profile = profile;

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmEntre(
    String email,
    String password,
  ) async {
    var response =
        await http.get('$_LocalIp/api/Users/${email}', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      var profile = Profile.fromJson(jsonDecode(response.body));

      if (profile.password == password) {
        CurrentUser.profile = profile;
        skillsCan =
            profile.skills.where((element) => element.status == 1).toList();
        skillsWant =
            profile.skills.where((element) => element.status == 2).toList();
        curExc = profile.transactions.where((element) => element.status == 1).toList();
        completedExc  = profile.transactions.where((element) => element.status == 2).toList().reversed.toList();
        inExc  = profile.transactions.where((element) => (element.status == 0 && element.receiverMail == profile.email)).toList().reversed.toList();
        outExc = profile.transactions.where((element) => (element.status == 0 && element.receiverMail != profile.email)).toList().reversed.toList();
        Api.getAllSkills().then((value) => {
              if (value.isSuccess()) {skills = value.getData()}
            });
      } else {
        return null;
      }
      return EventWrapper(response.statusCode, true, "Удачно");
    }
    if (response.statusCode == 404) {
      return null;
    }
    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Skill>>> getCanSkills(Profile profile) async {
    final response =
        await http.get('$_LocalIp/api/Skills/${profile.email}/skills');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Skill> skills =
          List<Skill>.from(l.map((model) => Skill.fromJson(model)));

      List<Skill> skillsCan = new List();

      for (int i = 0; i < skills.length; i++) {
        if (skills[i].status == 1) {
          skillsCan.add(skills[i]);
        }
      }
      return EventWrapper(response.statusCode, skillsCan, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Skill>>> getAllSkills() async {
    final response = await http
        .get('$_LocalIp/api/Users/${CurrentUser.profile.email}/skills');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      skills =
          List<Skill>.from(l.map((model) => Skill.fromJson(model))).reversed.toList();

      return EventWrapper(response.statusCode, skills, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> addSkill(Skill skill) async {
    var jsonEnc = json.encode(skill.toJson());
    var response = await http.post('$_LocalIp/api/Skills',
        body: jsonEnc, headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 201) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> deleteSkill(int id) async {
    var response =
        await http.delete('$_LocalIp/api/Skills/$id', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 204) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> deleteExchange(int id, bool sendNotification) async {
    var response =
        await http.delete('$_LocalIp/api/Transactions/$id?sendNotification=$sendNotification', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 204) {
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> editSkill(Skill skill) async {
    var response =
        await http.get('$_LocalIp/api/Skills/${skill.id}', headers: headers);
// todo проверить
    var skillToChange = Skill.fromJson(jsonDecode(response.body));

    skillToChange.name = skill.name;
    skillToChange.description = skill.description;
    skillToChange.subcategory = skill.subcategory;
    skillToChange.category = skill.category;

    var jsonEnc = json.encode(skillToChange.toJsonPut());

    var finalResponse = await http.put('$_LocalIp/api/Skills/${skill.id}',
        body: jsonEnc, headers: headers);

    print("Код: ${finalResponse.statusCode}");

    if (finalResponse.statusCode == 204) {
      return EventWrapper(finalResponse.statusCode, true, "Удачно");
    }

    if (finalResponse.body != null)
      return EventWrapper(finalResponse.statusCode, null, finalResponse.body);

    return EventWrapper(
        finalResponse.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> editExchange(Exchange exchange) async {
    var response = await http.get('$_LocalIp/api/Transactions/${exchange.id}',
        headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      var exchangeToChange = Exchange.fromJson(jsonDecode(response.body));


      bool curStatus = exchange.status == 2 && exchangeToChange.status == 1;
      exchangeToChange.status = exchange.status;
      exchangeToChange.skill1 = exchange.skill1;
      exchangeToChange.description = exchange.description;

      var jsonEnc = json.encode(exchangeToChange.toJsonPut());
      var finalResponse;

      if(curStatus) {
        finalResponse = await http.put(
            '$_LocalIp/api/Transactions/${exchange.id}?mail=${exchange.senderMail == CurrentUser.profile.email? exchange.senderMail: exchange.receiverMail}', body: jsonEnc,
            headers: headers);
      } else{
        finalResponse = await http.put(
            '$_LocalIp/api/Transactions/${exchange.id}', body: jsonEnc,
            headers: headers);
      }

      print("Код: ${finalResponse.statusCode}");

      if (finalResponse.statusCode == 204) {
        return EventWrapper(finalResponse.statusCode, true, "Удачно");
      }
      if (finalResponse.body != null)
        return EventWrapper(finalResponse.statusCode, null, finalResponse.body);

      return EventWrapper(finalResponse.statusCode, null,
          "Связь с сервером не была установлена");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<Skill>> getSkill(int id) async {
    var response = await http.get('$_LocalIp/api/Skills/$id', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Skill skill = Skill.fromJson(jsonDecode(response.body));

      return EventWrapper(response.statusCode, skill, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<Exchange>> getExchange(int id) async {
    var response =
        await http.get('$_LocalIp/api/Transactions/$id', headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Exchange exchange = Exchange.fromJson(jsonDecode(response.body));

      return EventWrapper(response.statusCode, exchange, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Skill>>> getWantSkills(
      Profile profile) async {
    final response =
        await http.get('$_LocalIp/api/Skills/${profile.email}/skills');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Skill> skills =
          List<Skill>.from(l.map((model) => Skill.fromJson(model)));

      List<Skill> skillsCan = new List();

      for (int i = 0; i < skills.length; i++) {
        if (skills[i].status == 2) {
          skillsCan.add(skills[i]);
        }
      }
      return EventWrapper(response.statusCode, skillsCan, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Skill>>> getSkillsOfUser(
      Profile profile) async {
    final response =
    await http.get('$_LocalIp/api/Skills/${profile.email}/skills');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Skill> skills =
      List<Skill>.from(l.map((model) => Skill.fromJson(model)));
      return EventWrapper(response.statusCode, skills, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getCompEx() async {
    final response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}/transactions/completed');

    print("Код: ${response.statusCode}");
    int code = 0;
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Exchange> exchanges =
          List<Exchange>.from(l.map((model) => Exchange.fromJson(model)));

      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail == CurrentUser.profile.email ? exchanges[i].senderMail : exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(response.statusCode, exchanges, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getCompExUsers(exchanges) async {
    int code = 0;
      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail == CurrentUser.profile.email ? exchanges[i].senderMail : exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(CurrentUser.profile);
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(200, exchanges, "Удачно");
  }

  static Future<EventWrapper<List<Exchange>>> getCurEx() async {
    final response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}/transactions/active');
    int code = 0;
    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Exchange> exchanges =
          List<Exchange>.from(l.map((model) => Exchange.fromJson(model)));

      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail == CurrentUser.profile.email ? exchanges[i].senderMail : exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(response.statusCode, exchanges, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getCurExUsers(exchanges) async {
    int code = 0;
      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail == CurrentUser.profile.email ?
            exchanges[i].senderMail : exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(CurrentUser.profile);
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(200, exchanges, "Удачно");
  }

  static Future<EventWrapper<List<Exchange>>> getInEx() async {
    final response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}/transactions/in');
    int code = 0;
    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Exchange> exchanges =
          List<Exchange>.from(l.map((model) => Exchange.fromJson(model)));
      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].senderMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(response.statusCode, exchanges, "Удачно");
      else
        return EventWrapper(400, null, "Связь с сервером не была установлена");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getInExUsers(exchanges) async {
    int code = 0;
      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].senderMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(200, exchanges, "Удачно");
      else
        return EventWrapper(400, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getOutExUsers(exchanges) async {
    int code = 0;
      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(200, exchanges, "Удачно");
      else
        return EventWrapper(400, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Exchange>>> getOutEx() async {
    final response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}/transactions/out');

    print("Код: ${response.statusCode}");
    int code = 0;
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Exchange> exchanges =
          List<Exchange>.from(l.map((model) => Exchange.fromJson(model)));

      for (int i = 0; i < exchanges.length; i++) {
        var response = await http.get(
            '$_LocalIp/api/Users/${exchanges[i].receiverMail}',
            headers: headers);

        var profile = Profile.fromJson(jsonDecode(response.body));

        print("Код: ${response.statusCode}");

        if (response.statusCode == 200) {
          exchanges[i].users.add(profile);
        } else {
          code = -1;
        }
      }
      if (code == 0)
        return EventWrapper(response.statusCode, exchanges, "Удачно");
      else
        return EventWrapper(400, null, "Связь с сервером не была установлена");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> addExchange(Exchange exchange) async {
    var jsonEnc = json.encode(exchange.toJson());
    var response = await http.post('$_LocalIp/api/Transactions',
        body: jsonEnc, headers: headers);

    print("Код: ${response.statusCode}");

    if (response.statusCode == 201) {
      final response = await http.get(
          '$_LocalIp/api/Users/${CurrentUser.profile.email}/transactions/out');
      print("Код: ${response.statusCode}");
      int code = 0;
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        List<Exchange> exchanges =
            List<Exchange>.from(l.map((model) => Exchange.fromJson(model)));

        for (int i = 0; i < exchanges.length; i++) {
          var response = await http.get(
              '$_LocalIp/api/Users/${exchanges[i].receiverMail}',
              headers: headers);

          var profile = Profile.fromJson(jsonDecode(response.body));

          if (response.statusCode == 200) {
            exchanges[i].users.add(profile);
          } else {
            code = -1;
          }
        }
        if (code == 0) {
          outExc = exchanges;
          print("Код: ${response.statusCode}");
        } else
          return EventWrapper(
              400, null, "Связь с сервером не была установлена");
      }
      return EventWrapper(response.statusCode, true, "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<bool>> confirmEdit(Profile profile) async {
    var response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        headers: headers);

    var profileIn = Profile.fromJson(jsonDecode(response.body));

    profileIn.password = profile.password;
    profileIn.name = profile.name;
    profileIn.surname = profile.surname;
    profileIn.socialNetwork = profile.socialNetwork;
    profileIn.aboutMe = profile.aboutMe;
    profileIn.stageOfEdu = profile.stageOfEdu;
    profileIn.eduProgram = profile.eduProgram;
    profileIn.campus = profile.campus;
    profileIn.dormitory = profile.dormitory;
    profileIn.birthday = profile.birthday;
    profileIn.gender = profile.gender;

    var jsonEnc = json.encode(profileIn.toJson());

    final responseFinal = await http.put(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}',
        body: jsonEnc,
        headers: headers);

    print("Код: ${responseFinal.statusCode}");

    if (responseFinal.statusCode == 204) {
      CurrentUser.profile = profile;
      return EventWrapper(responseFinal.statusCode, true, "Удачно");
    }

    if (responseFinal.body != null)
      return EventWrapper(responseFinal.statusCode, null, responseFinal.body);

    return EventWrapper(
        responseFinal.statusCode, null, "Связь с сервером не была установлена");
  }

  static Future<EventWrapper<List<Skill>>> getSkillsByParam(
      int studyingYearId,
      int majorId,
      int campus,
      int dorm,
      int gender,
      int category,
      int subcategory,
      int status) async {
    final response = await http.get(
        '$_LocalIp/api/Users/${CurrentUser.profile.email}/skills?studyingYearID=$studyingYearId&majorID=$majorId&'
        'campusLocationID=$campus&dormitoryID=$dorm&gender=$gender&skillstatus=$status&'
        'category=$category&subcategory=$subcategory');

    print("Код: ${response.statusCode}");

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Skill> skills =
          List<Skill>.from(l.map((model) => Skill.fromJson(model)));

      return EventWrapper(
          response.statusCode,
          skills.where((element) => element.category != null).toList(),
          "Удачно");
    }

    if (response.body != null)
      return EventWrapper(response.statusCode, null, response.body);

    return EventWrapper(
        response.statusCode, null, "Связь с сервером не была установлена");
  }
}
