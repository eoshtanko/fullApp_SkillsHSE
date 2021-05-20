import 'dart:convert';
import 'package:demoapp/data/skill.dart';
import 'package:json_annotation/json_annotation.dart';
import 'exchange.dart';
import 'generalInfo.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  String email;
  String name;
  String surname;
  String password;
  int gender;
  List<int> photoUri;
  int campus;
  int dormitory;
  int confirmationCodeServer;
  int confirmationCodeUser;
  int eduProgram;
  int stageOfEdu;
  String aboutMe;
  String socialNetwork;
  DateTime birthday;
  List<Exchange> transactions;
  List<Skill> skills;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  Profile(
      {this.email,
        this.confirmationCodeServer,
        this.confirmationCodeUser,
        this.password,
        this.name,
        this.surname,
        this.birthday,
        this.gender,
        this.stageOfEdu,
        this.eduProgram,
        String photoUri,
        this.campus,
        this.dormitory,
        this.aboutMe,
        this.socialNetwork,
        this.transactions,
        this.skills,
      }): photoUri = photoUri == null? null : Base64Decoder().convert(photoUri);

  DateTime get getBirthday {
    return birthday;
  }

  set setBirthday(DateTime value) {
    birthday = value;
  }

  String get getPassword {
    return password;
  }

  set setPassword(String value) {
    password = value;
  }

  String get getAboutMe {
    return aboutMe;
  }

  set setAboutMe(String value) {
    aboutMe = value;
  }

  String get getSocialNetwork {
    return socialNetwork;
  }

  set setSocialNetwork(String value) {
    socialNetwork = value;
  }

  String get getYearOfEdu {
    return stagesOfEdu[stageOfEdu];
  }

  set setYearOfEdu(String y) {
    stageOfEdu = stagesOfEdu.indexOf(y);
  }

  String get getEdu {
    return eduPrograms[eduProgram];
  }

  set setEdu(String edu) {
    eduProgram = eduPrograms.indexOf(edu);
  }

  String get getDormitory {
    return dormitories[dormitory];
  }

  set setDormitory(String dorm) {
    dormitory = dormitories.indexOf(dorm);
  }

  String get getBuilding {
    return buildings[campus];
  }

  set setBuilding(String build) {
    campus = buildings.indexOf(build);
  }

  String get getEmail {
    return email;
  }

  set setEmail(String e) {
    email = e;
  }

  String get getSex {
    return sexes[gender];
  }

  set setSex(String s) {
    gender = sexes.indexOf(s);
  }

  String get getName {
    return name;
  }

  set setName(String n) {
    name = n;
  }

  String get getSurname {
    return surname;
  }

  set setSurname(String n) {
    surname = n;
  }
}
