part of 'exchange.dart';

Exchange _$ExchangeFromJson(Map<String, dynamic> json) {
  return Exchange(
    id: json['id'] as int,
    skill1: json['skill1'] as String,
    skill2: json['skill2'] as String,
    description: json['description'] as String,
    senderMail: json['senderMail'] as String,
    receiverMail: json['receiverMail'] as String,
    whoWantMail: json['whoWantMail'] as String ,
    status: json['status'] as int,
    users: (json['users'] as List)
        ?.map(
            (e) => e == null ? null : Profile.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExchangeToJson(Exchange instance) => <String, dynamic>{
  'skill1': instance.skill1,
  'skill2': instance.skill2,
  'description': instance.description,
  'senderMail': instance.senderMail,
  'receiverMail': instance.receiverMail,
  'whoWantMail':instance.whoWantMail,
  'status': instance.status,
};

Map<String, dynamic> _$ExchangeToJsonPut(Exchange instance) => <String, dynamic>{
  'id': instance.id,
  'skill1': instance.skill1,
  'skill2': instance.skill2,
  'description': instance.description,
  'senderMail': instance.senderMail,
  'receiverMail': instance.receiverMail,
  'whoWantMail':instance.whoWantMail,
  'status': instance.status,
  'users': instance.users,
};
