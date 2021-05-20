import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill extends ChangeNotifier {
  String name;
  String description;
  int category;
  int subcategory;
  int status;
  String userMail;
  Map<String, dynamic> user;
  int id;

  Skill(this.id, this.status, this.name, this.description, this.category,
      this.subcategory, this.userMail, this.user);

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);

  Map<String, dynamic> toJsonPut() => _$SkillToJsonPut(this);

  int get getSubCategory {
    return subcategory;
  }

  set setSubCategory(int value) {
    subcategory = value;
  }

  int get getCategory {
    return category;
  }

  set setCategory(int value) {
    category = value;
  }

  int get getId {
    return id;
  }

  set setId(int value) {
    id = value;
  }

  String get getName {
    return name;
  }

  set setName(String value) {
    name = value;
  }

  String get getDescription {
    return description;
  }

  set setDescription(String value) {
    description = value;
  }
}
