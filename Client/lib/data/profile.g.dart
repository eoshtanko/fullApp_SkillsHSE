part of 'profile.dart';

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    email: json['mail'] as String,
    confirmationCodeServer: json['confirmationCodeServer'] as int,
    confirmationCodeUser: json['confirmationCodeUser'] as int,
    password: json['password'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    birthday: DateTime.parse(json['birthDate']),
    gender: json['gender'] as int,
    stageOfEdu: json['studyingYearId'] as int,
    eduProgram: json['majorId'] as int,
    campus: json['campusLocationId'] as int,
    dormitory: json['dormitoryId'] as int,
    aboutMe: json['about'] as String,
    socialNetwork: json['contact'] as String,
    photoUri: json['photo'] as String,
    transactions: (json['transactions'] as List)
        ?.map(
            (e) => e == null ? null : Exchange.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    skills: (json['skills'] as List)
        ?.map(
            (e) => e == null ? null : Skill.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) =>
    <String, dynamic>{
      'mail': instance.email,
      'confirmationCodeServer': instance.confirmationCodeServer,
      'confirmationCodeUser':instance.confirmationCodeUser,
      'password': instance.password,
      'name': instance.name,
      'surname': instance.surname,
      'birthDate': instance.birthday?.toIso8601String(),
      'gender': instance.gender,
      'studyingYearId': instance.stageOfEdu,
      'majorId': instance.eduProgram,
      'campusLocationId': instance.campus,
      'dormitoryId': instance.dormitory,
      'about': instance.aboutMe,
      'contact': instance.socialNetwork,
      'photo': instance.photoUri,
      'transactions': instance.transactions?.map((e) => e?.toJson())?.toList(),
      'skills': instance.skills?.map((e) => e?.toJson())?.toList(),
    };
