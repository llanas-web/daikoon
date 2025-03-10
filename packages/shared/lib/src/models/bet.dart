// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

part 'bet.g.dart';

@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class Bet extends Equatable {
  Bet({
    String? id,
    DateTime? createdAt,
    this.choiceId = '',
    this.userId = '',
    this.amount = 0,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);

  final String id;
  final DateTime createdAt;
  final String choiceId;
  final String userId;
  final int amount;

  Bet copyWith({
    String? id,
    DateTime? createdAt,
    String? choiceId,
    String? userId,
    int? amount,
  }) {
    return Bet(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      choiceId: choiceId ?? this.choiceId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        choiceId,
        userId,
        amount,
      ];
}
