// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

part 'bet.g.dart';

enum BetStatus { pending, done }

@immutable
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createToJson: false,
)
class Bet extends Equatable {
  Bet({
    String? id,
    DateTime? createdAt,
    this.choiceId = '',
    this.userId = '',
    this.amount = 0,
    this.status = BetStatus.pending,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);

  final String id;
  final DateTime createdAt;
  final String choiceId;
  final String userId;
  final int amount;
  final BetStatus status;

  Bet copyWith({
    String? id,
    DateTime? createdAt,
    String? choiceId,
    String? userId,
    int? amount,
    BetStatus? status,
  }) {
    return Bet(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      choiceId: choiceId ?? this.choiceId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        choiceId,
        userId,
        amount,
        status,
      ];
}
