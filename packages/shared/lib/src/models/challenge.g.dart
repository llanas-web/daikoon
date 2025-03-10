// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      id: json['id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      title: json['title'] as String? ?? '',
      question: json['question'] as String? ?? '',
      starting: json['starting'] == null
          ? null
          : DateTime.parse(json['starting'] as String),
      limitDate: json['limit_date'] == null
          ? null
          : DateTime.parse(json['limit_date'] as String),
      ending: json['ending'] == null
          ? null
          : DateTime.parse(json['ending'] as String),
      minBet: (json['min_bet'] as num?)?.toInt(),
      maxBet: (json['max_bet'] as num?)?.toInt(),
      hasBet: json['has_bet'] == null
          ? false
          : PowersyncJsonUtils.boolFromInt((json['has_bet'] as num).toInt()),
      creator: _$JsonConverterFromJson<Map<String, dynamic>, User>(
          json['creator'], const UserConverter().fromJson),
      choices: json['choices'] == null
          ? const []
          : const ListChoicesConverter().fromJson(json['choices'] as String),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'question': instance.question,
      'starting': instance.starting?.toIso8601String(),
      'ending': instance.ending?.toIso8601String(),
      'limit_date': instance.limitDate?.toIso8601String(),
      'min_bet': instance.minBet,
      'max_bet': instance.maxBet,
      'has_bet': PowersyncJsonUtils.boolToInt(instance.hasBet),
      'creator': _$JsonConverterToJson<Map<String, dynamic>, User>(
          instance.creator, const UserConverter().toJson),
      'choices': const ListChoicesConverter().toJson(instance.choices),
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
