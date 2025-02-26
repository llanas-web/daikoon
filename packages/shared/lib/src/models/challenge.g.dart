// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      title: json['title'] as String? ?? '',
      question: json['question'] as String? ?? '',
      starting: json['starting'] == null
          ? null
          : DateTime.parse(json['starting'] as String),
      limitDate: json['limitDate'] == null
          ? null
          : DateTime.parse(json['limitDate'] as String),
      ending: json['ending'] == null
          ? null
          : DateTime.parse(json['ending'] as String),
      minBet: (json['minBet'] as num?)?.toInt(),
      maxBet: (json['maxBet'] as num?)?.toInt(),
      hasBet: json['hasBet'] as bool? ?? false,
      creator: _$JsonConverterFromJson<Map<String, dynamic>, User>(
          json['creator'], const UserConverter().fromJson),
      choices: (json['choices'] as List<dynamic>?)
              ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'question': instance.question,
      'starting': instance.starting?.toIso8601String(),
      'ending': instance.ending?.toIso8601String(),
      'limitDate': instance.limitDate?.toIso8601String(),
      'minBet': instance.minBet,
      'maxBet': instance.maxBet,
      'hasBet': instance.hasBet,
      'creator': _$JsonConverterToJson<Map<String, dynamic>, User>(
          instance.creator, const UserConverter().toJson),
      'choices': instance.choices,
      'participants': instance.participants,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
