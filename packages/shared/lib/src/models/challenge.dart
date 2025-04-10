import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'challenge.g.dart';

/// {@template message}
/// The representation of the challenge.
/// {@endtemplate}
@immutable
@JsonSerializable(fieldRename: FieldRename.snake)
class Challenge extends Equatable {
  /// {@macro message}
  Challenge({
    String? id,
    DateTime? createdAt,
    this.title = '',
    this.question = '',
    this.starting,
    this.limitDate,
    this.ending,
    this.minBet,
    this.maxBet,
    this.hasBet = false,
    this.creator,
    this.choices = const [],
    this.participants = const [],
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  /// Creates a challenge from a json object.
  factory Challenge.fromJson(Map<String, dynamic> json) => _$ChallengeFromJson(
        json
          ..putIfAbsent(
            'creator',
            () => {
              'id': json['creator_id'],
              'username': json['creator_username'],
              'full_name': json['creator_full_name'],
              'avatar_url': json['creator_avatar_url'],
            },
          ),
      );

  /// The challenge's generated uuid.
  final String id;

  /// The challenge's creation date.
  final DateTime createdAt;

  /// The challenge's title.
  final String? title;

  /// The challenge's question.
  final String? question;

  /// The challenge's starting date.
  final DateTime? starting;

  /// The challenge's limit date.
  final DateTime? ending;

  /// The challenge's ending date.
  final DateTime? limitDate;

  /// The challenge's minimum bet.
  final int? minBet;

  /// The challenge's maximum bet.
  final int? maxBet;

  /// The challenge's bet status.
  @JsonKey(
    fromJson: PowersyncJsonUtils.boolFromInt,
    toJson: PowersyncJsonUtils.boolToInt,
  )
  final bool hasBet;

  /// The challenge's creator.
  @UserConverter()
  final User? creator;

  /// The challenge's options.
  @ListChoicesConverter()
  final List<Choice> choices;

  /// The challenge's participants.
  final List<Participant> participants;

  /// The challenge's status.
  bool get isEnded {
    return choices.isNotEmpty &&
            choices.any(
              (choice) => choice.isCorrect,
            ) ||
        ending != null && ending!.isBefore(DateTime.now());
  }

  /// The challenge's status.
  bool get isStarted => starting != null && starting!.isBefore(DateTime.now());

  /// The challenge's status.
  bool get isLimited =>
      limitDate != null && limitDate!.isBefore(DateTime.now());

  /// The challenge's status.
  bool get isPending => !isEnded && isStarted;

  /// Copy the current challenge with some new values.
  Challenge copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? question,
    DateTime? starting,
    DateTime? limitDate,
    DateTime? ending,
    int? minBet,
    int? maxBet,
    bool? hasBet,
    User? creator,
    List<Choice>? choices,
    List<Participant>? participants,
  }) =>
      Challenge(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        title: title ?? this.title,
        question: question ?? this.question,
        starting: starting ?? this.starting,
        limitDate: limitDate ?? this.limitDate,
        ending: ending ?? this.ending,
        minBet: minBet ?? this.minBet,
        maxBet: maxBet ?? this.maxBet,
        hasBet: hasBet ?? this.hasBet,
        creator: creator ?? this.creator,
        choices: choices ?? this.choices,
        participants: participants ?? this.participants,
      );

  /// The effective title display without null aware operators.
  @override
  List<Object?> get props => [
        id,
        createdAt,
        title,
        question,
        starting,
        limitDate,
        ending,
        minBet,
        maxBet,
        hasBet,
        creator,
        choices,
        participants,
      ];

  /// An empty challenge.
  static Challenge empty = Challenge();

  /// Creates a challenge from a json object.
  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}
