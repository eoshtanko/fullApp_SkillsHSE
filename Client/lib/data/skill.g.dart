part of 'skill.dart';

Skill _$SkillFromJson(Map<String, dynamic> json) {
  return Skill(
    json['id'] as int,
    json['status'] as int,
    json['name'] as String,
    json['description'] as String,
    json['category'] as int,
    json['subcategory'] as int,
    json['userMail'] as String,
    json['user'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
  'status': instance.status,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'subcategory': instance.subcategory,
  'userMail' : instance.userMail,
};

Map<String, dynamic> _$SkillToJsonPut(Skill instance) => <String, dynamic>{
  'id' : instance.id,
  'status': instance.status,
  'name': instance.name,
  'description': instance.description,
  'category': instance.category,
  'subcategory': instance.subcategory,
  'userMail' : instance.userMail,
  'user' : instance.user,
};
