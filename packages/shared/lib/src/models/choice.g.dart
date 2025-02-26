// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      id: json['id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      value: json['value'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'value': instance.value,
      'isCorrect': instance.isCorrect,
    };
