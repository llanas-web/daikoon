// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bet _$BetFromJson(Map<String, dynamic> json) => Bet(
      id: json['id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      choiceId: json['choice_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
    );
