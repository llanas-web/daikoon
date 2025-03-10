// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      id: json['id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      value: json['value'] as String? ?? '',
      isCorrect: json['is_correct'] == null
          ? false
          : PowersyncJsonUtils.boolFromInt((json['is_correct'] as num).toInt()),
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'value': instance.value,
      'is_correct': PowersyncJsonUtils.boolToInt(instance.isCorrect),
    };
