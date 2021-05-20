import 'package:demoapp/data/profile.dart';
import 'package:json_annotation/json_annotation.dart';
part 'exchange.g.dart';

@JsonSerializable()
class Exchange {

  String skill1;
  String skill2;
  String description;
  String senderMail;
  String receiverMail;
  String whoWantMail;
  int status;
  List<Profile> users;
  int id;

  Exchange({
    this.skill1,
    this.skill2,
    this.description,
    this.whoWantMail,
    this.senderMail,
    this.receiverMail,
    this.status,
    this.users,
    this.id,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) => _$ExchangeFromJson(json);

  Map<String, dynamic> toJsonPut() => _$ExchangeToJsonPut(this);

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);
}
